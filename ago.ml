(**
    Compute the number of days between two dates.

    New BSD License, see LICENSE.md.
    Copyright (c) 2015, Christian Lindig <lindig@gmail.com>

    @author Christian Lindig
*)

exception Error of string
let error fmt = Printf.kprintf (fun msg -> raise (Error msg)) fmt

(** Date in year, month 1..12, day 1..31 *)
type date = Date of int * int * int (** use [is_legal] for invariants *)

(** days in a month (0 .. 11) when not in a leap year, month is 0-based *)
let days   = [| 31; 28; 31; 30;  31;  30;  31;  31;  30;  31;  30;  31|]
let days'  = [|  0; 31; 59; 90; 120; 151; 181; 212; 243; 273; 304; 334|]
(** days'.(i) is the number of days in a year before month i when not 
    in a leap year; month is 0-based *)

(*** code to compute days'
let () =    
    let days' = Array.make 12 0 in
    let rec loop sum i =
        if i >= 12 then () else
            begin
                Array.set days' i sum;
                loop (sum+days.(i)) (i+1)
            end                
    in
        loop 0 0
***)

(** [days_since_1900.(i) is the number of days between 1.1.1900 and
    1.1.(1900+i). I'm planning to replace this by a function that
    computes this. When I first wrote this code I had no access to the
    internet to look up the date computation. *)

let days_since_1900 = [|
    0; 365; 730; 1095; 1460; 1826; 2191; 2556; 2921; 3287; 3652; 4017;
    4382; 4748; 5113; 5478; 5843; 6209; 6574; 6939; 7304; 7670; 8035; 8400;
    8765; 9131; 9496; 9861; 10226; 10592; 10957; 11322; 11687; 12053;
    12418; 12783; 13148; 13514; 13879; 14244; 14609; 14975; 15340; 15705;
    16070; 16436; 16801; 17166; 17531; 17897; 18262; 18627; 18992; 19358;
    19723; 20088; 20453; 20819; 21184; 21549; 21914; 22280; 22645; 23010;
    23375; 23741; 24106; 24471; 24836; 25202; 25567; 25932; 26297; 26663;
    27028; 27393; 27758; 28124; 28489; 28854; 29219; 29585; 29950; 30315;
    30680; 31046; 31411; 31776; 32141; 32507; 32872; 33237; 33602; 33968;
    34333; 34698; 35063; 35429; 35794; 36159; 36524; 36890; 37255; 37620;
    37985; 38351; 38716; 39081; 39446; 39812; 40177; 40542; 40907; 41273;
    41638; 42003; 42368; 42734; 43099; 43464; 43829; 44195; 44560; 44925;
    45290; 45656; 46021; 46386; 46751; 47117; 47482; 47847; 48212; 48578;
    48943; 49308; 49673; 50039; 50404; 50769; 51134; 51500; 51865; 52230;
    52595; 52961; 53326; 53691; 54056; 54422; 54787; 55152; 55517; 55883;
    56248; 56613; 56978; 57344; 57709; 58074; 58439; 58805; 59170; 59535;
    59900; 60266; 60631; 60996; 61361; 61727; 62092; 62457; 62822; 63188;
    63553; 63918; 64283; 64649; 65014; 65379; 65744; 66110; 66475; 66840;
    67205; 67571; 67936; 68301; 68666; 69032; 69397; 69762; 70127; 70493;
    70858; 71223; 71588; 71954; 72319; 72684; 73049; |]

(** Each testcase specifies two dates and the number of days between
    them. *)
let testcases = [
    ("1947-01-18", "2023-12-26", 28101);
    ("1986-09-16", "2040-11-25", 19794);
    ("2040-12-12", "1992-11-20", -17554);
    ("1974-08-27", "2050-12-22", 27876);
    ("2037-10-27", "1934-10-11", -37637);
    ("2012-09-20", "2045-06-24", 11965);
    ("1965-12-06", "1934-05-17", -11526);
    ("1918-12-31", "1984-04-30", 23862);
    ("1930-02-12", "2013-10-13", 30559);
    ("1988-06-22", "1924-01-14", -23536);
    ("2042-06-24", "2069-11-28", 10019);
    ("1927-02-18", "1922-01-20", -1855);
    ("2066-07-12", "2055-12-01", -3876);
    ("1981-09-28", "1932-07-13", -17974);
    ("1924-05-19", "1994-05-19", 25567);
    ("1922-09-10", "2071-12-20", 54523);
    ("2040-05-13", "1997-10-30", -15536);
    ("1927-08-31", "2031-11-08", 38055);
    ("2025-03-25", "2043-02-19", 6540);
    ("2012-10-26", "1970-01-31", -15609);
    ("2024-03-09", "1966-12-08", -20911);
    ("1933-06-15", "2049-09-08", 42454);
    ("2077-02-03", "2062-07-01", -5331);
    ("2012-11-12", "2017-07-29", 1720);
    ("1981-08-29", "1935-04-06", -16947);
    ("1950-08-04", "1949-06-05", -425);
    ("1962-04-13", "1942-09-21", -7144);
    ("2073-10-04", "2051-12-03", -7976);
    ("1990-06-15", "1925-01-01", -23906);
    ("2073-03-22", "1951-04-02", -44550);
    ("2048-03-19", "2057-12-25", 3568);
    ("1935-03-29", "1937-01-27", 670);
    ("2053-08-08", "1931-02-14", -44736);
    ("1938-10-12", "2037-08-01", 36088);
    ("1950-10-01", "1993-02-08", 15471);
    ("2054-03-30", "2038-07-05", -5747);
    ("2063-10-16", "2041-07-28", -8115);
    ("1998-09-22", "1933-03-18", -23929);
    ("1922-11-07", "2004-01-12", 29651);
    ("2054-06-30", "2058-10-05", 1558);
    ("2038-03-31", "2034-09-10", -1298);
    ("2049-05-03", "1953-02-28", -35128);
    ("2056-06-03", "1995-05-23", -22292);
    ("1940-06-07", "1986-03-27", 16729);
    ("1942-08-19", "1979-10-25", 13581);
    ("2058-07-19", "1935-05-05", -45001);
    ("2026-04-03", "1985-06-18", -14899);
    ("1914-01-20", "2021-09-27", 39332);
    ("1987-09-03", "1998-10-24", 4069);
    ("2001-12-22", "1988-02-05", -5069);
    ("2034-04-13", "1970-08-21", -23246);
    ("2010-12-23", "2009-06-18", -553);
    ("1996-05-11", "1997-03-13", 306);
    ("1939-03-11", "1940-02-06", 332);
    ("1947-12-02", "1978-08-02", 11201);
    ("1948-01-20", "1959-07-22", 4201);
    ("1958-06-06", "2077-01-06", 43314);
    ("1947-10-26", "1939-10-27", -2921);
    ("2046-12-24", "1937-06-18", -40001);
    ("1990-09-27", "2046-01-22", 20206);
    ("2077-06-09", "2044-11-20", -11889);
    ("2003-01-03", "1957-09-05", -16556);
    ("2015-07-24", "2021-11-03", 2294);
    ("1929-09-07", "1951-10-06", 8064);
    ("1971-03-20", "1996-12-02", 9389);
    ("2067-06-20", "2038-05-10", -10633);
    ("1958-10-26", "2005-12-09", 17211);
    ("2020-02-08", "2000-02-03", -7310);
    ("2070-07-02", "1944-07-25", -45998);
    ("1993-01-07", "1965-10-31", -9930);
    ("1955-10-05", "1958-02-10", 859);
    ("2026-02-22", "2058-02-02", 11668);
    ("1917-08-11", "2005-11-07", 32230);
    ("2066-02-26", "1934-11-13", -47953);
    ("1936-04-09", "1970-09-09", 12571);
    ("2033-03-24", "2005-09-02", -10065);
    ("2020-06-05", "1994-01-20", -9633);
    ("2075-02-15", "2069-05-24", -2093);
    ("2072-06-04", "1921-05-19", -55169);
    ("2023-03-26", "2038-09-11", 5648);
    ("2067-05-22", "2052-07-03", -5436);
    ("1980-05-11", "1948-03-04", -11756);
    ("1961-10-27", "1960-11-06", -355);
    ("1956-01-26", "2066-08-08", 40372);
    ("2011-12-02", "1952-05-10", -21755);
    ("1932-05-16", "1919-02-12", -4842);
    ("2067-07-17", "2011-09-24", -20385);
    ("2001-03-07", "1920-01-02", -29650);
    ("2038-08-22", "1922-03-21", -42523);
    ("2062-06-17", "2021-06-23", -14969);
    ("2067-12-06", "1942-09-06", -45747);
    ("2042-05-05", "2007-03-07", -12843);
    ("2061-09-02", "1999-03-01", -22831);
    ("1997-05-25", "2069-11-29", 26486);
    ("1933-08-10", "2004-08-05", 25928);
    ("2003-04-11", "2063-10-13", 22100);
    ("2054-03-13", "1995-11-25", -21293);
    ("2046-05-24", "1981-11-14", -23567);
    ("1974-05-09", "1917-03-28", -20861);
    ("1989-08-14", "2059-08-16", 25569);
    ("2051-06-15", "1965-08-06", -31359);
    ("1937-01-10", "1933-01-08", -1463);
    ("1985-02-26", "1943-05-21", -15257);
    ("2028-08-05", "2045-07-25", 6198);
    ("2069-12-11", "1917-05-18", -55725);
    ("1978-05-01", "2051-11-02", 26848);
    ("1942-05-18", "2063-08-28", 44297);
    ("1924-05-22", "1919-06-06", -1812);
    ("1936-04-06", "1987-11-30", 18865);
    ("1934-09-28", "2036-01-17", 37001);
    ("2033-08-24", "1933-06-03", -36607);
    ("1984-05-19", "2072-09-14", 32260);
    ("2075-01-27", "2071-09-07", -1238);
    ("2044-03-10", "2074-08-04", 11104);
    ("1958-12-26", "1959-04-24", 119);
    ("1929-09-23", "2030-12-04", 36962);
    ("1945-09-05", "1971-04-08", 9346);
    ("2002-01-19", "2016-08-22", 5329);
    ("1944-09-18", "2008-08-04", 23331);
    ("2021-07-09", "1962-05-11", -21609);
    ("1967-03-26", "2018-09-04", 18790);
    ("1958-10-12", "1972-08-31", 5072);
    ("1939-10-02", "2040-08-20", 36848);
    ("2037-08-20", "2004-03-16", -12210);
    ("1995-11-02", "1973-06-14", -8176);
    ("2073-01-27", "1934-11-28", -50465);
    ("2055-06-18", "2011-05-07", -16113);
    ("1949-07-11", "1999-08-28", 18310);
    ("2007-04-30", "2003-10-04", -1304);
    ("2075-10-11", "1970-11-11", -38320);
    ("2028-04-03", "2051-03-17", 8383);
    ("1959-03-02", "1931-12-15", -9939);
    ("2038-11-06", "2069-03-12", 11084);
    ("1946-06-16", "1974-01-08", 10068);
    ("1971-05-15", "1964-05-05", -2566);
    ("1927-03-10", "2077-09-17", 54979);
    ("2062-04-16", "2021-06-02", -14928);
    ("2044-03-20", "2068-08-01", 8900);
    ("2014-01-28", "2066-06-21", 19137);
    ("2019-01-17", "1952-11-03", -24181);
    ("1956-03-11", "1954-05-09", -672);
    ("1980-09-13", "1968-03-19", -4561);
    ("2024-04-08", "1935-05-03", -32483);
    ("1926-05-04", "1934-12-21", 3153);
    ("2066-11-07", "2058-04-11", -3132);
    ("2020-06-13", "2037-08-18", 6275);
    ("1979-04-10", "1946-07-20", -11952);
    ("1957-09-04", "1960-11-13", 1166);
    ("1941-12-09", "2033-01-07", 33267);
    ("2016-09-22", "2061-02-24", 16226);
    ("2000-02-26", "1998-09-05", -539);
    ("2041-03-27", "1920-08-04", -44065);
    ("2024-03-30", "1984-09-29", -14427);
    ("2023-11-03", "1982-05-22", -15140);
    ("2065-07-07", "1961-03-08", -38107);
    ("2072-10-20", "1949-02-11", -45177);
    ("1949-02-08", "1979-09-28", 11189);
    ("1934-02-14", "2032-02-05", 35785);
    ("1951-06-02", "2074-07-11", 44965);
    ("2026-01-19", "2065-12-26", 14586);
    ("2045-09-02", "2030-09-21", -5460);
    ("1921-12-06", "1965-10-12", 16016);
    ("1980-12-31", "2037-12-30", 20818);
    ("1945-06-07", "1928-01-21", -6347);
    ("1973-06-27", "2060-07-12", 31792);
    ("2006-08-23", "1988-02-17", -6762);
    ("1993-07-29", "1946-11-25", -17048);
    ("1988-04-27", "2021-10-29", 12238);
    ("2045-06-11", "2018-11-23", -9697);
    ("2009-12-03", "1948-02-26", -22561);
    ("2051-08-01", "2025-11-05", -9400);
    ("1944-03-18", "1953-08-15", 3437);
    ("1913-10-16", "2060-10-28", 53704);
    ("2043-01-26", "2049-06-03", 2320);
    ("2040-05-20", "2052-06-09", 4403);
    ("2015-11-09", "2025-01-21", 3361);
    ("2045-11-18", "1989-05-09", -20647);
    ("1919-04-25", "2061-12-09", 52094);
    ("1946-12-19", "1974-10-27", 10174);
    ("2067-07-21", "2028-09-12", -14191);
    ("1949-01-01", "1941-08-30", -2681);
    ("2008-06-05", "2075-07-25", 24521);
    ("2044-05-16", "1924-12-28", -43604);
    ("2045-12-04", "1985-11-16", -21933);
    ("2076-11-27", "2070-05-25", -2378);
    ("2018-02-12", "1980-03-08", -13855);
    ("2029-02-15", "1964-09-16", -23528);
    ("1996-02-14", "1940-04-06", -20402);
    ("2031-08-01", "1976-02-17", -20254);
    ("2035-12-14", "2065-10-25", 10908);
    ("2069-05-01", "1988-08-05", -29489);
    ("2056-11-18", "2062-01-22", 1891);
    ("1923-08-22", "2025-02-22", 37075);
    ("2071-10-22", "1914-09-01", -57395);
    ("1963-09-02", "1937-11-18", -9419);
    ("2043-08-30", "1936-01-25", -39299);
    ("1929-10-23", "1925-08-22", -1523);
    ("2005-06-01", "2034-08-26", 10678);
    ("2053-07-10", "2010-11-15", -15578);
    ("1982-01-22", "1955-02-23", -9830);
]

(** [is_leapyear] is true, if a year is a leap year *)
let is_leapyear year =
        year mod 4    = 0
    &&  year mod 100 != 0
    ||  year mod 400  = 0

(** number of days in a month of a given year *)
let days_in_month year month =
    if is_leapyear year && month = 2 
    then 29
    else days.(month-1) (* array is zero-based, month is one-based *)

(** [day_of_year] returns the zero-based day of the year. Hence,
    1.1.2010 is day 0 in 2010 and 31.12.2010 is day 364 because 2010
    is a not leap year *)
let day_of_year = function Date(yy, mm, dd) ->
    let leapday = if is_leapyear yy && mm > 2 then 1 else 0 in
        days'.(mm-1) + dd - 1 + leapday

let days_since_1900 = function Date(yy, mm, dd) as date ->
        days_since_1900.(yy - 1900) + day_of_year(date)

(** [is_legal] is true if and only if
    - a date is legal 
    - and can be handled by this program *)
let is_legal = function Date(yy, mm, dd) ->
           1 <= mm && mm <= 12
    &&  1900 <= yy && yy <= 2099 
    &&     1 <= dd && dd <= days_in_month yy mm

(** The current local date *)
let now =
    let (yy, mm, dd) = Agolex.now in 
        Date(yy, mm, dd)

(** [date_from_string] parses a date from a string. @raise Error if
    - it can't recognize a date
    - the date is illegal
    - the date is possibly legal can't be handled *)
let date_from_string str =
    let (yy, mm, dd) = Agolex.from_string str in
    let d = Date(yy, mm, dd) in
        if is_legal d then d else error "not a legal date: %s" str

(** [string_of_date] returns a string representation for a date *)
let string_of_date = function Date(yy, mm, dd) ->  
    Printf.sprintf "%04d-%02d-%02d" yy mm dd
    
(** Difference between two dates in days *)
let diff d1 d2 = (days_since_1900 d1) - (days_since_1900 d2)
let print d1 d2 =
    Printf.printf "%s - %s = %+4d\n" 
        (string_of_date d1)
        (string_of_date d2)
        (diff d1 d2)

(** run test cases. @return true, iff all test cases pass *)
let test () =
    let check (date_x, date_y, days) =
        let dx = date_from_string date_x in
        let dy = date_from_string date_y in
            diff dy dx = days
    in
        List.for_all check testcases

let rec process = function
    | dx :: dy :: ds -> print dx dy; process (dy :: ds)
    | dx :: []       -> print dx now
    | []             -> ()

(** [main] handldes command line arguments. *)
let main () =
    let argv    = Array.to_list Sys.argv            in
    (* let this    = List.hd argv |> Filename.basename in
     *)
    let dates   = List.tl argv |>  List.map date_from_string in
        begin
            assert (test ());
            process dates
        end    

let () = if not !Sys.interactive then begin main (); exit 0 end
        
