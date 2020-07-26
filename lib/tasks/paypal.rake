namespace :paypal do
  namespace :plans do
    desc 'Sync Paypal plans with database'
    task sync: :environment do
      Paypal::SyncPlansService.new.sync
    end

    desc 'upload Paypal plans with all price combinations'
    task upload: :environment do
      Paypal::UploadPlansService.new.upload
    end
  end
end
