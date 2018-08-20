require 'csv'

class Survey

  def initialize(answers)
    @answers = answers.values
    save_to_json
  end

  def self.email_is_present?(email)
    csv_text = File.read('public/answers.csv')
    csv = CSV.parse(csv_text, :headers => true)
    !csv.find {|row| row['Email'] == email}.nil?
  end

  def self.replies
    csv_text = File.read('public/answers.csv')
    csv = CSV.parse(csv_text, :headers => true)
    data1 = {"Yes": 0, "No": 0}
    data2 = {"Yes": 0, "No": 0}
    data3 = {"Yes": 0, "No": 0}
    data4 = {"Yes": 0, "No": 0}
    data5 = {"Yes": 0, "No": 0}
    csv.each do |row|
      row['Question1'] == 'yes' ? data1[:Yes] += 1 : data1[:No] += 1
      row['Question2'] == 'yes' ? data2[:Yes] += 1 : data2[:No] += 1
      row['Question3'] == 'yes' ? data3[:Yes] += 1 : data3[:No] += 1
      row['Question4'] == 'yes' ? data4[:Yes] += 1 : data4[:No] += 1
      row['Question5'] == 'yes' ? data5[:Yes] += 1 : data5[:No] += 1
    end
    replies =[{
                name: 'Do you like our product?',
                data: data1.to_a
              },
              {
                name: 'Are you willing to buy again?',
                data: data2.to_a
              },
              {
                name: 'Would you suggest our product to one of your friends?',
                data: data3.to_a
              },
              {
                name: 'Would you suggest our product to one of your relatives?',
                data: data4.to_a
              },
              {
                name: 'Have you ever purchased products of our company before?',
                data: data5.to_a
              }]
    replies
  end

  def self.total_replies
    CSV.foreach('public/answers.csv', headers: true).count
  end


  def self.positive_negative_replies_count
    csv_text = File.read('public/answers.csv')
    csv = CSV.parse(csv_text, :headers => true)
    data = {"yes": 0, "no":0}
    csv.each do |row|
      row['Question1'] == 'yes' ? data[:yes] += 1 : data[:no] += 1
      row['Question2'] == 'yes' ? data[:yes] += 1 : data[:no] += 1
      row['Question3'] == 'yes' ? data[:yes] += 1 : data[:no] += 1
      row['Question4'] == 'yes' ? data[:yes] += 1 : data[:no] += 1
      row['Question5'] == 'yes' ? data[:yes] += 1 : data[:no] += 1
    end
    data
  end

  private

  def save_to_json
    CSV.open('public/answers.csv', 'a+') do |row|
      row << @answers
    end
  end
end
