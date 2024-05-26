require 'aws-sdk-s3'

class ApplicationController < ActionController::API

  attr_reader :current_user

  def authenticate_user_request
    begin
      if decoded_auth_token == nil
        return render json: { error: "Invalid token" }, status: 401 unless @current_user
      end
      @current_user = AuthorizeApiRequest.call("user", decoded_auth_token[:user_id]).result
    rescue StandardError => error
     render json: { error: error }, status: 401 unless @current_user
    end
  end

  def authenticate_admin_request
    begin
      if decoded_auth_token == nil
        return render json: { error: "Invalid token" }, status: 401 unless @current_user
      end
      if(decoded_auth_token[:level] == "admin")
      @current_user = AuthorizeApiRequest.call("admin", decoded_auth_token[:user_id] ).result
      else
       render json: { error: 'Your not an admin' }, status: 403 unless @current_user
      end
    rescue StandardError => error
      render json: { error: error }, status: 500 unless @current_user
    end
  end

  def decoded_auth_token
    @decoded_auth_token = JsonWebToken.decode(http_auth_token)
    if(@decoded_auth_token == nil)
       StandardError.new "Invalid Token"
    end
    return @decoded_auth_token
  end

  def http_auth_token
    if request.headers['Authorization'].present?
      return request.headers['Authorization'].split(' ').last
    else
      StandardError.new "Missing Token"
    end
  end


  def current_user_id
    @current_user[:id]
  end

  def write_file_to_storage(file, path)
    FileUtils.mkdir_p(path) unless File.exist?(path)
  
    File.open(File.join(path, file.original_filename), "wb") do |f|
      f.write(file.read)
    end
  end

  def upload_to_s3(s3_client, object_key, request_file)
    @tmp_path = "#{Rails.root}/tmp/storage/user_avatar"
    write_file_to_storage(request_file, @tmp_path)
    splitted_file_name = request_file.original_filename.split('.', 2)
    file_format = splitted_file_name[1]
    File.open(@tmp_path+'/'+request_file.original_filename, 'rb') do |file|
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
