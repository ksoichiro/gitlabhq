# encoding: utf-8
class Admin::ServicesController < Admin::ApplicationController
  before_action :service, only: [:edit, :update]

  def index
    @services = services_templates
  end

  def edit
    unless service.present?
      redirect_to admin_application_settings_services_path,
        alert: "不明なサービスまたは存在しないサービスです"
    end
  end

  def update
    if service.update_attributes(application_services_params[:service])
      redirect_to admin_application_settings_services_path,
        notice: 'アプリケーション設定を保存しました'
    else
      render :edit
    end
  end

  private

  def services_templates
    templates = []

    Service.available_services_names.each do |service_name|
      service_template = service_name.concat("_service").camelize.constantize
      templates << service_template.where(template: true).first_or_create
    end

    templates
  end

  def service
    @service ||= Service.where(id: params[:id], template: true).first
  end

  def application_services_params
    params.permit(:id,
      service: Projects::ServicesController::ALLOWED_PARAMS)
  end
end
