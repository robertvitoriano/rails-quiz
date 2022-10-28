require 'aws-sdk-s3'

class ApplicationController < ActionController::API
  private
  def encode_token(user_id)
    payload = { user_id: user_id }
    JWT.encode(payload, api_secret, 'HS256')
  end

  def api_secret
    ENV["API_SECRET_KEY"]
  end

  def client_has_valid_token?
    !!current_user_id
  end

  def current_user_id
    begin
      token = request.headers["Authorization"].sub!('Bearer ', '')
      decoded_array = JWT.decode(token, api_secret, true, { algorithm: 'HS256' })
      payload = decoded_array.first
    rescue #JWT::VerificationError
      return nil
    end
    payload["user_id"]
  end

  def require_login
    render json: {error: 'Unauthorized'}, status: :unauthorized if !client_has_valid_token?
  end


  def write_file_to_storage(file, path)
    FileUtils.mkdir(path) unless File.exists?(path)

    File.open(File.join(path,file.original_filename),"wb") { |f| f.write(file.read)}
  end

  def upload_to_s3(s3_client, object_key, request_file)
    @tmp_path = "#{Rails.root}/tmp/storage/course_covers"
    write_file_to_storage(request_file, @tmp_path)
    File.open(@tmp_path+'/'+course_params[:cover].original_filename, 'rb') do |file|
      upload_to_s3(s3_client, object_key, file)
      s3_client.put_object(
        bucket: ENV["S3_BUCKET"],
        key: object_key,
        acl:'public-read',
        content_type:'image/png',
        content_disposition:'attachment',
        body: file
      )
    end
  rescue StandardError => e
    puts "Error uploading object: #{e.message}"
    return false
  end

end
