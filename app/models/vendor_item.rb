class VendorItem < ApplicationRecord
  belongs_to :vendor
  belongs_to :item
  
  def create_item
    VendorItem.transaction do
      latestItemEntry = VendorItem.where(item_id: self.item_id,
              vendor_id: self.vendor_id).last

      version = latestItemEntry.blank? ? 1 : latestItemEntry.version + 1
      self.version = version
      self.save!
    end
  end
end
