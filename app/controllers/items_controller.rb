class ItemsController < ApplicationController
  before_action :set_item, except: [:index, :new, :create, :get_category_children, :get_category_grandchildren]
  before_action :category_parent_array, only: [:new, :create, :edit]

  def index
    @items = Item.includes(:images).order(updated_at: "desc")
    @item = @items.where(category_id: 131)
  end

  def new
    @item = Item.new
    @item.images.build
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
    @user = User.find(@item.seller_id)
    @parents = Categorie.where(ancestry:nil)
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to item_path notice: '更新しました'
    else
      render 'edit'
    end
  end

  def destroy
  end

  def confirm
  end

  def get_category_children
    @category_children = Categorie.where('ancestry = ?', "#{params[:parent_name]}")
  end

  def get_category_grandchildren
    @category_grandchildren = Categorie.where('ancestry LIKE ?', "%/#{params[:child_id]}")
  end

  private

  def item_params
    params.require(:item).permit(:name, :detail, :price, :status_id, :postage_id, :shipping_day_id, :shipping_method_id, :prefecture_id, :brand, :category_id, :buyre_id, :seller_id, images_attributes: [:image, :_destroy, :id]).merge(seller_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def category_parent_array
    @category_parent_array = Categorie.where(ancestry: nil)        # ⑧ 親カテゴリーを全てインスタンス変数へ代入
  end

end
