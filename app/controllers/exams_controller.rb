require "net/http"
require "uri"

class ExamsController < ApplicationController
  def index
    uri = URI("https://learn.viblo.asia")
    res = Net::HTTP.get_response(uri)

    cookies = res.get_fields("set-cookie")

    csrf = cookies
    .find { |c| c.start_with?("XSRF-TOKEN=") }
    .split(";").first.split("=").last

    cookie_header = cookies.map { |c| c.split(";").first }.join("; ")
    cookie_header += "; viblo_session_nonce="
    cookie_header += "; viblo_learning_auth=="
    raw = Viblo::Exams.new(
      url: "https://learn.viblo.asia/api/exams/76/tests/create?language=en",
      cookies: cookie_header,
      x_xsrf_token: csrf
    ).create_test

    parsed = JSON.parse(raw)
    @exam_data = parsed["data"]
    @exam = @exam_data&.dig("exam") || {}
    @questions = @exam_data&.dig("questions") || []
    session[:exam_hash_id] = @exam_data["hashId"] if @exam_data&.key?("hashId")
  rescue JSON::ParserError
    @exam_data = nil
    @exam = {}
    @questions = []
  end

  def create
    uri = URI("https://learn.viblo.asia")
    res = Net::HTTP.get_response(uri)

    cookies = res.get_fields("set-cookie")

    csrf = cookies
    .find { |c| c.start_with?("XSRF-TOKEN=") }
    .split(";").first.split("=").last

    cookie_header = cookies.map { |c| c.split(";").first }.join("; ")
    cookie_header += "; viblo_session_nonce="
    cookie_header += "; viblo_learning_auth=="

    hash_id = session[:exam_hash_id]
    unless hash_id.present?
      redirect_to exams_path, alert: "Phiên làm bài không hợp lệ. Vui lòng bắt đầu lại từ trang đề thi."
      return
    end
    answers_hash = params[:answers].present? ? params[:answers].to_unsafe_h : {}
    submissions = build_submissions_from_params(answers_hash)

    Viblo::Exams.new(
      url: "https://learn.viblo.asia/api/tests/#{hash_id}/submissions",
      cookies: cookie_header,
      x_xsrf_token: csrf
    ).submit_submissions(submissions)
    redirect_to exam_path(hash_id), notice: "Đã nộp bài thành công."
  rescue Faraday::Error => e
    redirect_to exams_path, alert: "Lỗi khi nộp bài: #{e.message}"
  end

  def show
    uri = URI("https://learn.viblo.asia")
    res = Net::HTTP.get_response(uri)

    cookies = res.get_fields("set-cookie")

    csrf = cookies
    .find { |c| c.start_with?("XSRF-TOKEN=") }
    .split(";").first.split("=").last

    cookie_header = cookies.map { |c| c.split(";").first }.join("; ")
    cookie_header += "; viblo_session_nonce="
    cookie_header += "; viblo_learning_auth=="

    @hash_id = params[:id]

    raw = Viblo::Exams.new(
      url: "https://learn.viblo.asia/api/tests/#{@hash_id}/result",
      cookies: cookie_header,
      x_xsrf_token: csrf
    ).get_result
    @result_data = JSON.parse(raw)
  rescue Faraday::Error => e
    @error = e.message
    @result_data = nil
  rescue JSON::ParserError
    @error = "Không thể đọc kết quả."
    @result_data = nil
  end

  private

  # Chuyển params[:answers] từ form thành mảng theo format Viblo:
  # Chọn 1: [{ question_id: 43014, answers: 170402 }]
  # Chọn nhiều: [{ question_id: 43189, answers: [171027, 171028] }]
  def build_submissions_from_params(answers_params)
    return [] if answers_params.blank?

    answers_params.map do |question_id_str, value|
      qid = question_id_str.to_i
      answers = Array.wrap(value).map { |v| v.to_s.to_i }.compact
      next if answers.empty?

      item = { question_id: qid }
      item[:answers] = answers.size == 1 ? answers.first : answers
      item
    end.compact
  end
end
