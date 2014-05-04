# encoding: utf-8
# == Schema Information
#
# Table name: services
#
#  id          :integer          not null, primary key
#  type        :string(255)
#  title       :string(255)
#  token       :string(255)
#  project_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  active      :boolean          default(FALSE), not null
#  project_url :string(255)
#  subdomain   :string(255)
#  room        :string(255)
#  api_key     :string(255)
#

class EmailsOnPushService < Service
  attr_accessible :recipients

  validates :recipients, presence: true, if: :activated?

  def title
    'Emails on push'
  end

  def description
    '各プッシュのコミットと差分をメール送信します。'
  end

  def to_param
    'emails_on_push'
  end

  def execute(push_data)
    EmailsOnPushWorker.perform_async(project_id, recipients, push_data)
  end

  def fields
    [
      { type: 'textarea', name: 'recipients', placeholder: 'Emails separated by whitespace' },
    ]
  end
end
