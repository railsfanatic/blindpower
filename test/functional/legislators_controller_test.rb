require 'test_helper'

class LegislatorsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Legislator.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Legislator.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Legislator.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to legislator_url(assigns(:legislator))
  end
  
  def test_edit
    get :edit, :id => Legislator.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Legislator.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Legislator.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Legislator.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Legislator.first
    assert_redirected_to legislator_url(assigns(:legislator))
  end
  
  def test_destroy
    legislator = Legislator.first
    delete :destroy, :id => legislator
    assert_redirected_to legislators_url
    assert !Legislator.exists?(legislator.id)
  end
end
