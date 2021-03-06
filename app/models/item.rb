class Item < ActiveRecord::Base
  TYPES = ["roll","raised","cake","donut_hole","Supplies"]
  belongs_to :delivery
  has_many :line_items, :dependent => :destroy
  
  validates_presence_of :name, :item_type, :price
  validates_uniqueness_of :name
  
  has_and_belongs_to_many :deliveries
  
  named_scope :available, :conditions => {:available => true}
  named_scope :consumable, :conditions => ["item_type != ?",TYPES.last]

  def discounted?
    name =~ /discount/i
  end

  def consumable?
    self.item_type != TYPES.last
  end
  
  def self.types
    @types ||= TYPES.collect{ |t| t.titleize }
  end
    
  def self.metric_chart(store = nil)
    chrt = GoogleChart.pie_3d_400x100(metrics(store).freeze)
    chrt.colors = CHART_COLORS[:pie] * (self.count / 2).round
    chrt
  end
  
  def self.metrics(store = nil)
    extend ActionView::Helpers::TextHelper
    collection = store.nil? ? find(:all, :include => [:line_items], :conditions => ["item_type != ?",TYPES.last]) : store.line_items.map{|li| li.item if li.item.consumable? }.flatten
    collection.group_by{|i| i.item_type }.map { |item_type_name, items|
      qty   = items.map(&:line_items).flatten.map(&:quantity).to_s.sum
      price = items.map(&:line_items).flatten.map(&:price).to_s.sum
      [item_type_name.titleize,qty,price]
    }
  end
end
