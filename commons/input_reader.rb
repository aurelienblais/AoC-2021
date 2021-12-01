# frozen_string_literal: true

class InputReader
  attr_reader :file, :content, :parsed_content

  def initialize(file:)
    @file = file
  end

  def read
    @content = File.read(@file)
    @parsed_content = @content.split("\n").map(&:strip)

    self
  end
end
