require 'aws-sdk-s3'

class ApplicationController < ActionController::API

  attr_reader :current_user

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end

  def authenticate_user_request
    @current_user = AuthorizeApiRequest.call("user", decoded_auth_token[:user_id]).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end

  def authenticate_admin_request
   if(decoded_auth_token[:level] == "admin")
    @current_user = AuthorizeApiRequest.call("admin", decoded_auth_token[:user_id] ).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
   else
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
   end
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
    @decoded_auth_token || errors.add(:token, 'Invalid token') && nil
  end

  def http_auth_header
    if request.headers['Authorization'].present?
      return request.headers['Authorization'].split(' ').last
    else
      errors.add(:token, 'Missing token')
    end
    nil
  end


  def current_user_id
    @current_user[:id]
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
