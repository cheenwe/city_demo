### 国家
class Local::Contuny < Local
  has_many :provinces, class_name: "Local::Province", foreign_key: :parent_id

end
