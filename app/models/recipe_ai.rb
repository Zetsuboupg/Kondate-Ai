require 'httparty'
require 'json'

class RecipeAi
  OPENAI_API_KEY = 'わたしのkey'

  def self.suggest_recipes(ingredients)
    prompt = "Suggest 3 meal options using the following ingredients: #{ingredients}. Provide two options that might require additional shopping, and one or two that can be made with these ingredients only."

    response = HTTParty.post(
      "https://api.openai.com/v1/chat/completions", # エンドポイントを修正
      headers: {
        "Authorization" => "Bearer #{OPENAI_API_KEY}",
        "Content-Type" => "application/json"
      },
      body: {
        model: "gpt-4", # モデル指定
        messages: [
          { role: "system", content: "You are a helpful assistant." },
          { role: "user", content: prompt }
        ],
        max_tokens: 150
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
