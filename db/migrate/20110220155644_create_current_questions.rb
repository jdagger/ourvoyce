class CreateCurrentQuestions < ActiveRecord::Migration
  def self.up
    create_table :current_questions do |t|
      t.string :question_text
      t.string :question_title
      t.integer :active
      t.datetime :start_date
      t.datetime :end_date
      t.timestamps
    end

    create_table :current_question_supports do |t|
      t.integer :current_question_id
      t.integer :user_id
      t.integer :support_type
      t.timestamps
    end
  end

  def self.down
    drop_table :current_questions
    drop_table :current_question_supports
  end
end
