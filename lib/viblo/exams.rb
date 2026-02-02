module Viblo
  class Exams
    def initialize(url:, cookies:, x_xsrf_token:)
      @url = url
      @cookies = cookies
      @x_xsrf_token = x_xsrf_token
    end

    def create_test
      response = Faraday.post(@url, {
        language: "en"
      }, {
        "Cookie" => @cookies,
        "X-XSRF-TOKEN" => @x_xsrf_token
      })

      response.body
    end

    # POST nộp bài: body [{ question_id:, answers: (số hoặc mảng) }, ...]
    def submit_submissions(submissions)
      headers = {
        "Content-Type" => "application/json",
        "Cookie" => @cookies,
        "X-XSRF-TOKEN" => @x_xsrf_token
      }
      response = Faraday.post(@url, { answers: submissions, status: "submitted" }.to_json, headers)
      response.body
    end

    # GET kết quả bài thi: GET .../tests/:hash_id/result
    def get_result
      response = Faraday.get(@url, {}, {
        "Cookie" => @cookies,
        "X-XSRF-TOKEN" => @x_xsrf_token
      })
      response.body
    end
  end
end
