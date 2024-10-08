Rails.application.routes.draw do
  resources :recipes, only: [:new, :create] # :new と :create アクションを使う

  # 新しいレシピ提案のフォームを表示するルート
  #get 'recipes/new', to: 'recipes#new', as: 'new_recipe'

  # レシピ提案を作成するルート
  #post 'recipes', to: 'recipes#create'

  # ルート設定 (ホームページで新しいレシピフォームに飛ぶようにする)
  root to: 'recipes#new'
end