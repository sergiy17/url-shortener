# frozen_string_literal: true

class ReportException < ApplicationService
  attr_reader :exception

  def initialize(exception)
    @exception = exception
  end

  def call
    Rails.logger.error(report_info)
    # Sentry.capture_exception(exception)
    # pseudo code, this might grow into a service for tracking exceptions
  end

  private

  def report_info
    {
      message: exception&.message,
      backtrace: exception&.backtrace&.join("\n"),
    }
  end
end
