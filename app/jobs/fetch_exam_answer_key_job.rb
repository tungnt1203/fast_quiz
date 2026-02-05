# frozen_string_literal: true

class FetchExamAnswerKeyJob < ApplicationJob
  queue_as :default

  discard_on Gemini::CorrectAnswerFetcher::MissingApiKey
  discard_on OpenRouter::CorrectAnswerFetcher::MissingApiKey

  def perform(exam_session_id)
    session = ExamSession.find_by(id: exam_session_id)
    return unless session

    session.fetch_correct_answers!
  end
end
