class PostsController < ApplicationController
  def index
    @exams = Viblo::Exams.new(url: "https://learn.viblo.asia/api/exams/76/tests/create?language=en", cookies: {
      "Cookie" => "_gid=GA1.2.1489043533.1769880995; _ga_HF9XE2NDGV=GS2.1.s1769881007$o1$g0$t1769881007$j60$l0$h37891230; _csrf=HJBWo7CFSgiiXdGswzienvej; socket_broadcaster=pusher; socket_key=eycautetp5a6qpjwdp32; auth_endpoint=undefined; socket_host=pusha.viblo.asia; wsPort=; wssPort=; viblo_session_nonce=85c4dd2750da3de8b80462fb94124e654b05e78a4819439afe1a2a966eee7d6c; viblo_learning_auth=eyJpdiI6InpKbnNBVXZhUkVSZFRrdFJwa1U3alE9PSIsInZhbHVlIjoiWUQ2UEg0TFlQdWI4cEZtVlVHd01oMmJVa25DRmNQVXl4VTZyemk3dlNcL0JIOVBpdDV5a09LMXc4QnZ6QnQ0VjRhanJxYXZvZHl0K2ptbEoxTmtQWXVJNjEybCtWT0JzYXU5U2tVMXQzZVdWSDBsVE14MWhPdmY2R2ZicEpCK2JqeGYzYmdiRXZcL1Q3XC9sTkg2cnFqcDRRPT0iLCJtYWMiOiIxYTA0OTZlN2Q2OTI4MzI0YWExYzJmNmZkZjVhMGMxN2YyM2E4ZTMwNmRjZjE2MmEwZjdjMDZiNDAwOGE3NmQxIn0%3D; connect.sid=s%3Ak7SxaPaybEFEE_fz-PgqgvkW8LDNQKfz.V5806t1MyWnRyHD015V0kBnzBwi3kLo43hxGkfnlQr8; _ga=GA1.1.352668989.1769880995; _ga_BC15S2FB10=GS2.1.s1769881068$o1$g0$t1769881070$j58$l0$h0; XSRF-TOKEN=SL3uyK3I-f0IeFsa4lEkhDBRt2lM7j_Kztcg; _ga_LCJPWMSS52=GS2.1.s1769881023$o1$g1$t1769881130$j60$l0$h0",
      "X-XSRF-TOKEN" => "SL3uyK3I-f0IeFsa4lEkhDBRt2lM7j_Kztcg"
    }).create_test
  end
end
