class CreateApprovalRequests < ActiveRecord::Migration
  def change
    create_table :approval_requests do |t|

      t.references :approvable, polymorphic: true
      t.text       :notes

      t.datetime   :approved_at
      t.datetime   :refused_at

      t.timestamps null: false
    end
  end
end
