class ProductsController < ApplicationController

  def index
    @title = t('view.products.index_title')
    if params[:type].present?
      case params[:type]
        when 'CustomProduct'  then @products = CustomProduct.page(params[:page])
        when 'RawMaterial'    then @products = RawMaterial.page(params[:page])
        else                  @products = Product.page(params[:page])
      end
    else
      @products = Product.page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  def show
    @product = Product.includes(interests: [:product_histories, :sale_histories]).find(params[:id])
    @title = t('view.products.show_title', product: @product.name)
    @interests = @product.interests
    @purchase_interests
    #todo: sale_interests, purchase_interests
    #@product_histories = ProductHistory.where(interest_id: @product.interests.map(&:id))
    #@sale_histories = SaleHistory.where(interest_id: @product.interests.map(&:id))

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  def new
    @product = Product.new
    @title = t('view.products.new_title')

    render partial: 'new', content_type: 'text/html'
  end

  def edit
    @product = Product.find(params[:id])
    @title = t('view.products.edit_title', product: @product.name)

    render partial: 'edit', content_type: 'text/html'
  end

  def create
    @product = Product.new(params[:product])
    @title = t('view.products.new_title')
    @product.user = @current_user

    if @product.save
      render partial: 'product', locals: { product: @product }, content_type: 'text/html'
    else
      render partial: 'new', status: :unprocessable_entity
    end
  end

  def update
    @product = Product.find(params[:id])
    @title = t('view.products.edit_title')

    if @product.update_attributes(params[:product])
      # todo: no esta actualizando bien el tipo de producto.
      render partial: 'product', locals: { product: @product }, content_type: 'text/html'
    else
      render partial: 'edit', status: :unprocessable_entity
    end
  rescue ActiveRecord::StaleObjectError
    js_redirect to: edit_product_url(@product)
    js_notify message: t('view.products.stale_object_error')
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      render nothing: true, content_type: 'text/html'
    else
      render nothing: true
    end
  end
end
