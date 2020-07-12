namespace :paypal do
  namespace :plans do
    desc 'Sync Paypal plans with database'
    task sync: :environment do
      Paypal::SyncPlansService.new.sync
    end
  end
end
