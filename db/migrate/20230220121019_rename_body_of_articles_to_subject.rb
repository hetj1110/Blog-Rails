class RenameBodyOfArticlesToSubject < ActiveRecord::Migration[7.0]
  def change
    rename_column :articles, :body, :subject
  end
end
