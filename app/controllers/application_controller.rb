class ApplicationController < ActionController::API
  def render_errors(record)
    render json: { errors: record.errors.messages,
                   messages: record.errors.full_messages },
           status: :unprocessable_entity
  end
end
