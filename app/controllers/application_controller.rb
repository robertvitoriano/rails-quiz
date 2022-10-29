require 'aws-sdk-s3'

class ApplicationController < ActionController::API

  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end

  def current_user_id
    @current_user.id
  end

  def write_file_to_storage(file, path)
    FileUtils.mkdir(path) unless File.exists?(path)

    File.open(File.join(path,file.original_filename),"wb") { |f| f.write(file.read)}
  end

  def upload_to_s3(s3_client, object_key, request_file)
    @tmp_path = "#{Rails.root}/tmp/storage/course_covers"
    write_file_to_storage(request_file, @tmp_path)
    splitted_file_name = course_params[:cover].original_filename.split('.', 2)
    file_format = splitted_file_name[1]
    File.open(@tmp_path+'/'+course_params[:cover].original_filename, 'rb') do |file|
      s3_client.put_object(
        bucket: ENV["S3_BUCKET"],
        key: object_key,
        acl:'public-read',
        content_type:'image/'+file_format,
        content_disposition:'attachment',
        body: file
      )
    end
  rescue StandardError => e
    puts "Error uploading object: #{e.message}"
    return false
  end

end
