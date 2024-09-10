class RecipesController < ApplicationController
  def new
    # 新しいレシピ提案フォームの表示
  end

  def create
    ingredients = params[:ingredients]

    # APIを呼び出してレシピ提案を取得
    @recipe_suggestions = RecipeAi.suggest_recipes(ingredients)

    # レシピ提案結果を表示するためにshowビューを表示
    render :show
  end

  def show
    # `create`から呼ばれることを想定しているため、特に処理は不要かもしれません
    # @recipe_suggestionsは`create`で設定されるため、ここには何も設定しない
  end
end
