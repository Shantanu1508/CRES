export class UtilsFunctions {
  convertDateToBindable(date) {
    var dateObj = null;
    if (date) {
      if (typeof (date) == "string") {
        date = date.replace("Z", "");
        dateObj = new Date(date);
      }
      else {
        dateObj = date;
      }
      if (dateObj != null) {
        return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
      }
    }
  }
  convertDateToBindableWithformatchar(date,formatchar) {
    var dateObj = null;
    if (date) {
      if (typeof (date) == "string") {
        date = date.replace("Z", "");
        dateObj = new Date(date);
      }
      else {
        dateObj = date;
      }
      if (dateObj != null) {
        return this.getTwoDigitString(dateObj.getMonth() + 1) + formatchar + this.getTwoDigitString(dateObj.getDate()) + formatchar + dateObj.getFullYear();
      }
    }
  }

  convertDateWithoutSlash(date) {
    var dateObj = null;
    if (date) {
      if (typeof (date) == "string") {
        date = date.replace("Z", "");
        dateObj = new Date(date);
      }
      else {
        dateObj = date;
      }
      if (dateObj != null) {
        return this.getTwoDigitString(dateObj.getMonth() + 1) + this.getTwoDigitString(dateObj.getDate()) + dateObj.getFullYear();
      }
    }
  }
  convertDateToUTC(date) {
    var dateObj = null;
    if (date) {
      if (typeof (date) == "string") {
        date = date.replace("Z", "");
        dateObj = new Date(date);
      }
      else {
        dateObj = date;
      }
      if (dateObj != null) {
        var tempdate = new Date(Date.UTC(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), 3, 0, 0));
        return tempdate;
        //return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear();
      }
    }
  }
  getTwoDigitString(number) {
    if (number.toString().length === 1)
      return "0" + number;
    return number;
  }
  GetDefaultValueNumber(val) {
    if (isNaN(val) || val == null) {
      return 0;
    }
    return val;
  }

  formatNumberforTwoDecimalplaces(data, currencytext) {
    if (data == null || data === undefined) {
      data = 0;
    }
    var num = parseFloat(data.toFixed(2));
    var str = num.toString();
    var numarray = str.split('.');
    var a = new Array();
    a = numarray;
    var newamount;
    //to assign 2 digits after decimal places
    if (a[1]) {
      var l = a[1].length;
      if (l == 1) {
        data = num + "0";
      }
      else {
        data = num;
      }
    } else {
      data = num + ".00";
    }

    //to assign currency with sign
    if (Math.sign(data) == -1) {
      var _amount = -1 * data;
      newamount = "-" + this.GetCurrencySymbol(currencytext) + _amount;
    }
    else {
      newamount = this.GetCurrencySymbol(currencytext) + data;
    }
    var changedamount = newamount.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
    return changedamount;
  }

  convertToTwoDecimalPlaces(data) {
    if (data == null || data === undefined) {
      data = 0;
    }
    var num = parseFloat(data).toFixed(2);
    return parseFloat(num);
  }

  GetCurrencySymbol(CurrencyText): any {
    var _basecurrencyname = "";
    if (CurrencyText == "USD") {
      _basecurrencyname = '$';
    }
    else if (CurrencyText == "GBP") {
      _basecurrencyname = '£';
    }
    else if (CurrencyText == "EUR") {
      _basecurrencyname = '€';
    } else { _basecurrencyname = '$'; }
    return _basecurrencyname;
  }
  formatNumberTopercent(num) {
    var s;
    s = Intl.NumberFormat("en-us", {
      style: "percent",
      minimumFractionDigits: 1,
      maximumFractionDigits: 2
    }).format(num);
    return s;
  }

  convertDatetoGMT(date: Date) {
    var _dtUTCHours: number;
    var _userOffset: number;
    var _centralOffset: number;

    var _date = new Date();
    _dtUTCHours = _date.getTimezoneOffset() / 60;
    _userOffset = _date.getTimezoneOffset() * 60 * 1000; // user's offset time

    if (_dtUTCHours < 6) {
      _centralOffset = 6 * 60 * 60 * 1000; // 6 for central time - use whatever you need
    }
    else {
      _centralOffset = _dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
    }

    if (date != null) {
      date = new Date(date);
      var _userOffset = date.getTimezoneOffset() * 60 * 1000; // user's offset time
      var _centralOffset = _dtUTCHours * 60 * 60 * 1000; // 6 for central time - use whatever you need
      date = new Date(date.getTime() - _userOffset + _centralOffset); // redefine variable
      return date;
    }
    else
      return date;
  }

  convertDateToBindableWithTime(date) {
    var dateObj = new Date(date);
    return this.getTwoDigitString(dateObj.getMonth() + 1) + "/" + this.getTwoDigitString(dateObj.getDate()) + "/" + dateObj.getFullYear() + " " + dateObj.getHours() + ":" + dateObj.getMinutes() + ":" + dateObj.getSeconds();
  }

  getnextbusinessDate(sDate: Date, noofDays: number, addorsub: boolean, ListHoliday: any): Date {
    if (sDate) {
      var i = 0;
      while (i < Math.abs(noofDays)) {
        var daycnt = sDate.getDay();
        var formateddate = this.convertDateToBindable(sDate);
        if (addorsub == true) {
          if (daycnt == 6 || daycnt == 0
            || ListHoliday.filter(x => this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411).length > 0
          ) {
            sDate.setDate(sDate.getDate() + 1);
          }
          if (daycnt == 1 || daycnt == 2 || daycnt == 3 || daycnt == 4 || daycnt == 5) {
            sDate.setDate(sDate.getDate() + 1);
            i++;
          }

        }
        else {
          if (daycnt == 6 || daycnt == 0
            || ListHoliday.filter(x => this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411).length > 0
          ) {
            sDate.setDate(sDate.getDate() - 1);
          }
          else {
            sDate.setDate(sDate.getDate() - 1);
            i++;
          }

        }
      }
    }
    for (var j = 0; j < 7; j++) {
      formateddate = this.convertDateToBindable(sDate);
      var daycnt = sDate.getDay();
      if (daycnt == 6 || daycnt == 0
        || ListHoliday.filter(x => this.convertDateToBindable(x.HolidayDate) == formateddate && x.HolidayTypeID == 411).length > 0
      ) {
        sDate.setDate(sDate.getDate() - 1);

      }
      else
        return sDate;
    }

    return sDate;
  }

  ///string utils

  SubstringFromLast(str) {
    if (str != "") {
      str = str.substring(0, str.length - 1);
    }
    return str;
  }


  //number utils

  ConverttoFloat(d) {
    var number = 0;
    if (d != null && d !== undefined) {
      number = parseFloat(d);
    } else {
      number = 0;
    }
    return number;
  }

  DivideIfNotZero(numerator, denominator) {
    try {
      if (denominator === 0 || isNaN(denominator)) {
        return 0;
      }
      else {
        return numerator / denominator;
      }
    } catch (e) {
      return 0;

    }
  }
}
