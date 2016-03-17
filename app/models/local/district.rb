### 区/县城
class Local::District < Local
  has_many :streets, class_name: "Local::Street", foreign_key: :parent_id

  belongs_to :city, class_name: "Local::City", foreign_key: :parent_id
end
