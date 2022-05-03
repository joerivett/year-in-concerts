module ViewModels
  class Error
    def initialize(errors)
      @errors = errors
    end

    def errors?
      @errors.any?
    end

    def error_content
      @errors.first
    end
  end
end
