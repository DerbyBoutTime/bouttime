class AddOfficialReviewsRetainedToTeamState < ActiveRecord::Migration
  def change
    add_column :team_states, :official_reviews_retained, :integer, default: 0
  end
end
