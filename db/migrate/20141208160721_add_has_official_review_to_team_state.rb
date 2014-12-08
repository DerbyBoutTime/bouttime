class AddHasOfficialReviewToTeamState < ActiveRecord::Migration
  def change
    add_column :team_states, :has_official_review, :boolean
  end
end
