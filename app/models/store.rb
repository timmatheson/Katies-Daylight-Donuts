class Store < ActiveRecord::Base
  belongs_to :city
  belongs_to :user, :dependent => :destroy # customer
  belongs_to :route
  has_many :deliveries, :dependent => :destroy
  has_many :line_items, :through => :deliveries
  has_many :delivery_presets, :dependent => :destroy
  has_many :buy_backs, :through => :deliveries
    
  # Geocode the locations for mapping
  after_update  :get_geocode
  before_create :get_geocode
  before_validation_on_create :set_position
  before_validation :find_or_create_city
  
  validates_presence_of :name, :address, :city, :state, :country, :zipcode, :position # important!
    
  validates_numericality_of :zipcode
  
  validates_length_of :state, :is => 2
  
  acts_as_mappable
  
  attr_accessor :manual_city
  
  named_scope :all_by_position, :order => "position asc", :include => [:route, :city]
  
  def to_param
    "#{id}-#{name}".gsub(/[^A-Za-z0-9]/,'-')
  end
  
  # Returns the city name titleized
  def city_name
    @city_name ||= city.name.titleize
  end
  
  # Class method calls, the instance method create_todays_delivery!
  # on all deliveries in order of their position.
  def self.create_todays_deliveries!
    deliveries = []
    all_by_position.each do |store|
      begin
        deliveries << store.create_todays_delivery!
      rescue Exception => e
        logger.error e.message
        next # keep it movin
      end
    end
    deliveries = deliveries.compact
    deliveries
  end
  
  # Can be called on any store to genertae todays delivery.
  # Todays delivery is defined by todays DeliveryPreset.
  def create_todays_delivery!
    unless todays_ticket.nil? || is_closed_today? || has_delivery_for_today?
    delivery = deliveries.create({
      :employee => Employee.default,
      :delivery_date => Time.zone.today
    })
      todays_ticket.line_items.each do |line_item|
        delivery.add_item(line_item.item, line_item.quantity) unless line_item.quantity.to_i < 1
      end
    end
    delivery
  end

  # Returns the current balance for a store (includes discounts for buy backs)
  def balance
     (deliveries.delivered.unpaid.map(&:total).sum - buy_backs.map(&:total).sum)
  end
  
  def has_delivery_for_today?
    @has_delivery_for_today ||= !deliveries.pending.find(:first, :conditions => ["delivery_date between ? and ?",Time.zone.now.beginning_of_day.to_s(:db),Time.zone.now.midnight.to_s(:db)]).nil?
  end
  
  def is_closed_today?
    todays_ticket && todays_ticket.closed?
  end
  
  # Returns todays ticket, which is really tomorrow in this case
  def todays_ticket
    @todays_ticket ||= delivery_presets.find_by_day_of_week(tomorrow)
  end

  def tomorrow
    (Time.zone.now+1.day).strftime("%a").downcase
  end
  
  def display_name
    @display_name ||= store_no.blank? ? name.titleize : [name.titleize, store_no].join(" - ")
  end
  
  def full_address
    <<-EOF
    #{address}<br />
    #{city.name}, #{state}<br />
    #{country} #{zipcode}
    EOF
  end
  
  def address_option
    to_google
  end
  
  def to_google
    "#{address} #{city.name}, #{state}\n #{country} #{zipcode}"
  end
  
  def geocode
    geocode_array.join(",")
  end

  def geocode_array
    [lat,lng]
  end

  # Returns a safe name for creating a username
  def safe_name
    name.gsub(/[^A-Za-z0-9\_]/,'').downcase
  end

  private

  def find_or_create_city
    self.city = City.find_or_create_by_name(self.manual_city) unless self.manual_city.blank?
    true
  end
  
  def get_geocode
    gc = Geokit::Geocoders::YahooGeocoder.geocode "#{address}, #{city}, #{state}"
    self.lat = gc.lat
    self.lng = gc.lng
    true
  end
  
  def set_position
    return true unless self.position.nil?
    self.position = 0
    true
  end
end
