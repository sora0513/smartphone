# =Android

module Smartphone::Sphone
  # ==Android携帯電話
  class Android < AbstractSphone

    # 対応するUser-Agentの正規表現
    USER_AGENT_REGEXP = /((Android).+Mobile.+Safari)/

    # 画面情報を +Display+ クラスのインスタンスで返す。
    def display
      return @__display if @__display

      p_w = p_h = col_p = cols = nil
      if r = @request.env['HTTP_X_UP_DEVCAP_SCREENPIXELS']
        p_w, p_h = r.split(/,/,2).map {|x| x.to_i}
      end
      if r = @request.env['HTTP_X_UP_DEVCAP_ISCOLOR']
        col_p = (r == '1')
      end
      if r = @request.env['HTTP_X_UP_DEVCAP_SCREENDEPTH']
        a = r.split(/,/)
        cols = 2 ** a[0].to_i
      end
      @__display = Smartphone::Display.new(p_w, p_h, nil, nil, col_p, cols)
    end

    # cookieに対応しているか？
    def supports_cookie?
      false
    end

private
    # モデル名を返す。
    def model_name
      if @request.env["HTTP_USER_AGENT"] =~ /^DoCoMo\/2.0 (.+)\(/
        return $1
      elsif @request.env["HTTP_USER_AGENT"] =~ /^DoCoMo\/1.0\/(.+?)\//
        return $1
      end
      return nil
    end
  end
end
