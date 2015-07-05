class Micropost < ActiveRecord::Base
  DEFAULT_PER_PAGE = 10
  belongs_to :user
  # The way to tell CarrierWave to associate the image with a model is to use the
  # mount_uploader method, which takes as arguments a symbol representing the
  # attribute and the class name of the generated uploader
  mount_uploader :picture, PictureUploader
  # used to set the default order in which elements are retrieved from the database
  # in this example we order the microposts by created_at desc.
  default_scope -> { order(created_at: :desc) }
  validates :content, length: { maximum: 140 }, :presence => true
  validates :user_id, presence: true, presence: true
  # Note the use of validate (as opposed to validates) to call a custom validation
  validate  :picture_size


  private

  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
