# encoding: utf-8
module Gitlab
  class IssuesLabels
    class << self
      def generate(project)
        red = '#d9534f'
        yellow = '#f0ad4e'
        blue = '#428bca'
        green = '#5cb85c'

        labels = [
          { title: "不具合", color: red },
          { title: "重要", color: red },
          { title: "確認済み", color: red },
          { title: "ドキュメンテーション", color: yellow },
          { title: "サポート", color: yellow },
          { title: "ディスカッション", color: blue },
          { title: "提案", color: blue },
          { title: "改善", color: green }
        ]

        labels.each do |label|
          project.labels.create(label)
        end
      end
    end
  end
end
