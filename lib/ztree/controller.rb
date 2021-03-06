module Ztree
  module Controller
    extend ActiveSupport::Concern
    def get_tree
      mo_str = params[:model_name]
      ztree_name = params[:ztree_name] || 'name'
      checked_ids = params[:checked_ids] || ''
      the_model = Object.const_get(mo_str)
      conditions = ''
      conditions += "name like '%#{params[:query]}%'" if params[:query]
      objs = the_model.where(conditions)
      opts = { 
        name: ztree_name,
        checked_ids: checked_ids
      }   
      render text: objs.to_ztree_node(opts).to_json        
    end 
  
    def sort_tree
      return render text: 'error' unless params[:model_name]
      mo_str = params[:model_name]
      the_model = Object.const_get(mo_str)
      arr = params[:sorted_array]
      p_id = arr.shift
      parent = p_id != '0' ? the_model.find(p_id) : the_model
      parent.update_sorted_numbers(arr)
      render text: arr 
    end 
  end 
end

# module Ztree
#   class Railtie < Rails::Railtie
#     initializer "ztree.action_controller" do
#       ActiveSupport.on_load(:action_controller) do
#         # include Ztree::Controller
#         ActionController::Base.send :include, Ztree::Controller 
#       end
#     end
#   end
# end
 
