# == Schema Information
#
# Table name: penalties
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  code       :string(255)
#  sort       :integer
#  created_at :datetime
#  updated_at :datetime
#
class Penalty < ActiveRecord::Base
  has_and_belongs_to_many :skater_states

	def self.demo
    [
      Penalty.find_or_create_by({
        name: 'High Block',
        code: 'A',
        sort: 0
      }),
      Penalty.find_or_create_by({
        name: 'Insubordination',
        code: 'N',
        sort: 1
      }),
      Penalty.find_or_create_by({
        name: 'Back Block',
        code: 'B',
        sort: 2
      }),
      Penalty.find_or_create_by({
        name: 'Skating Out of Bnds.',
        code: 'S',
        sort: 3
      }),
      Penalty.find_or_create_by({
        name: 'Elbows',
        code: 'E',
        sort: 4
      }),
      Penalty.find_or_create_by({
        name: 'Cutting the Track',
        code: 'X',
        sort: 5
      }),
      Penalty.find_or_create_by({
        name: 'Forearms',
        code: 'F',
        sort: 6
      }),
      Penalty.find_or_create_by({
        name: 'Delay of Game',
        code: 'Z',
        sort: 7
      }),
      Penalty.find_or_create_by({
        name: 'Misconduct',
        code: 'G',
        sort: 8
      }),
      Penalty.find_or_create_by({
        name: 'Dir. of Game Play',
        code: 'C',
        sort: 9
      }),
      Penalty.find_or_create_by({
        name: 'Blocking with Head',
        code: 'H',
        sort: 10
      }),
      Penalty.find_or_create_by({
        name: 'Out of Bounds',
        code: 'O',
        sort: 11
      }),
      Penalty.find_or_create_by({
        name: 'Low Block',
        code: 'L',
        sort: 12
      }),
      Penalty.find_or_create_by({
        name: 'Out of Play',
        code: 'P',
        sort: 13
      }),
      Penalty.find_or_create_by({
        name: 'Multi-Player Block',
        code: 'M',
        sort: 14
      }),
      Penalty.find_or_create_by({
        name: 'Illegal Procedure',
        code: 'I',
        sort: 15
      }),
      Penalty.find_or_create_by({
        name: 'Gross Misconduct',
        code: 'G',
        sort: 16
      }),
    ]
  end
  def as_json
    super(except: [:created_at, :updated_at])
  end
end
