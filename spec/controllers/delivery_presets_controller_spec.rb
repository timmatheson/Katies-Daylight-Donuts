require File.dirname(__FILE__) + '/../spec_helper'
 
describe DeliveryPresetsController do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => DeliveryPreset.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    DeliveryPreset.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    DeliveryPreset.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(delivery_preset_url(assigns[:delivery_preset]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => DeliveryPreset.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    DeliveryPreset.any_instance.stubs(:valid?).returns(false)
    put :update, :id => DeliveryPreset.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    DeliveryPreset.any_instance.stubs(:valid?).returns(true)
    put :update, :id => DeliveryPreset.first
    response.should redirect_to(delivery_preset_url(assigns[:delivery_preset]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    delivery_preset = DeliveryPreset.first
    delete :destroy, :id => delivery_preset
    response.should redirect_to(delivery_presets_url)
    DeliveryPreset.exists?(delivery_preset.id).should be_false
  end
end