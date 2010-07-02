require 'test_helper'

class SuggestionsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Suggestion.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Suggestion.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Suggestion.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to suggestion_url(assigns(:suggestion))
  end
  
  def test_edit
    get :edit, :id => Suggestion.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Suggestion.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Suggestion.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Suggestion.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Suggestion.first
    assert_redirected_to suggestion_url(assigns(:suggestion))
  end
  
  def test_destroy
    suggestion = Suggestion.first
    delete :destroy, :id => suggestion
    assert_redirected_to suggestions_url
    assert !Suggestion.exists?(suggestion.id)
  end
end
