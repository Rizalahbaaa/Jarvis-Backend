class AttachUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  include Cloudinary::CarrierWave
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  def public_id
    "public/files/#{filename}"
  end

  def filename
    "#{original_filename}" if original_filename.present?
  end

  protected

  def extension_allowlist
    %w(jpg jpeg png pdf)
  end

  def size_range
    1.byte..2.megabytes
  end
end
