String convertTimeAMPM(DateTime departTime) =>
    "${departTime.hour}:${departTime.minute}${departTime.hour > 12 ? "PM" : "AM"}";
