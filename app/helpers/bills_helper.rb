module BillsHelper
  def summarize_link(bill)
    n = bill.summary_word_count.roundup(1000)
    s = "Full Summary - #{number_with_delimiter(n)} words"
    "... (" + link_to(s, summarize_bill_path(bill)) + ")"
  end
  
  def read_link(bill)
    n = bill.text_word_count.roundup(1000)
    s = "Full Text ~ #{number_with_delimiter(n)} words"
    link_to(s, read_bill_path(bill))
  end
end
