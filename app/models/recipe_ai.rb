require 'httparty'
require 'json'

class RecipeAi
  OPENAI_API_KEY = ENV['OPENAI_API_KEY'] # 環境変数からAPIキーを読み込む

  def self.suggest_recipes(ingredients)
    prompt = "以下の食材を使って、3つの献立を提案してください: #{ingredients}。1つは現在の食材のみで作れるメニュー、2つは追加の買い物が必要なメニューを提案してください。"

    response = HTTParty.post(
      "https://api.openai.com/v1/chat/completions", # エンドポイントを修正
      headers: {
        "Authorization" => "Bearer #{OPENAI_API_KEY}",
        "Content-Type" => "application/json"
      },
      body: {
        model: "gpt-3.5-turbo", # モデル指定
        messages: [
          { role: "system", content: "You are a helpful assistant." },
          { role: "user", content: prompt }
        ],
        max_tokens: 1000
      }.to_json
    )

    # エラーハンドリング
    if response.code != 200
      return "APIリクエストが失敗しました。"
    end

    # レスポンスの中身をログに出力してデバッグ
    Rails.logger.info("API Response: #{response.body}")

    # レスポンスをパースして提案を返す
    parsed_response = JSON.parse(response.body)

    # レスポンスのチェック
    if parsed_response["choices"].nil? || parsed_response["choices"].empty?
      return "APIからの返答がありませんでした。"
    end

    # 提案された献立のテキストを返す
    parsed_response["choices"].first["message"]["content"]
  end
end
