import ballerina/http;

type TrainInfo record {|
    readonly string entryId;
    string startTime;
    string endTime;
    string 'from;
    string to;
    string trainType;
|};

table<TrainInfo> key(entryId) trains = table [];

isolated service / on new http:Listener(9090) {
    function init() returns error? {
        trains.add({entryId: "1", startTime: "10:00", endTime: "11:00", 'from: "Colombo", to: "Kandy", trainType: "Express"});
        trains.add({entryId: "2", startTime: "11:00", endTime: "12:00", 'from: "Colombo", to: "Kandy", trainType: "Express"});
        trains.add({entryId: "3", startTime: "12:00", endTime: "13:00", 'from: "Colombo", to: "Kandy", trainType: "Express"});
        trains.add({entryId: "4", startTime: "13:00", endTime: "14:00", 'from: "Colombo", to: "Kandy", trainType: "Express"});
        trains.add({entryId: "5", startTime: "14:00", endTime: "15:00", 'from: "Colombo", to: "Kandy", trainType: "Express"});
        trains.add({entryId: "6", startTime: "15:00", endTime: "16:00", 'from: "Colombo", to: "Kandy", trainType: "Express"});
        trains.add({entryId: "7", startTime: "16:00", endTime: "17:00", 'from: "Colombo", to: "Kandy", trainType: "Express"});
        trains.add({entryId: "8", startTime: "17:00", endTime: "18:00", 'from: "Colombo", to: "Kandy", trainType: "Express"});
        trains.add({entryId: "9", startTime: "18:00", endTime: "19:00", 'from: "Colombo", to: "Kandy", trainType: "Express"});
        trains.add({entryId: "10", startTime: "19:00", endTime: "20:00", 'from: "Colombo", to: "Kandy", trainType: "Express"});
        trains.add({entryId: "11", startTime: "20:00", endTime: "22:00", 'from: "Colombo", to: "Galle", trainType: "Normal"});
        trains.add({entryId: "12", startTime: "21:00", endTime: "23:00", 'from: "Colombo", to: "Galle", trainType: "Normal"});
        trains.add({entryId: "13", startTime: "10:00", endTime: "12:00", 'from: "Colombo", to: "Galle", trainType: "Normal"});
        trains.add({entryId: "14", startTime: "11:00", endTime: "13:00", 'from: "Colombo", to: "Galle", trainType: "Normal"});
        trains.add({entryId: "15", startTime: "12:00", endTime: "14:00", 'from: "Colombo", to: "Galle", trainType: "Normal"});
        trains.add({entryId: "16", startTime: "13:00", endTime: "15:00", 'from: "Colombo", to: "Galle", trainType: "Normal"});
        trains.add({entryId: "17", startTime: "14:00", endTime: "16:00", 'from: "Colombo", to: "Galle", trainType: "Normal"});
        trains.add({entryId: "18", startTime: "15:00", endTime: "17:00", 'from: "Colombo", to: "Galle", trainType: "Normal"});
        trains.add({entryId: "19", startTime: "16:00", endTime: "18:00", 'from: "Galle", to: "Colombo", trainType: "Normal"});
        trains.add({entryId: "20", startTime: "17:00", endTime: "19:00", 'from: "Galle", to: "Colombo", trainType: "Normal"});
        trains.add({entryId: "21", startTime: "8:00", endTime: "10:00", 'from: "Galle", to: "Colombo", trainType: "Normal"});
    }

    resource function get trains(string 'from, string to) returns record {|TrainInfo[] trains;|}|error {
        TrainInfo[] selectedTrains = trains.filter(train => train.'from == 'from && train.to == to).toArray();
        if selectedTrains.length() == 0 {
            return error("No trains found");
        }
        return {trains: selectedTrains};
    }

    resource function post bookTrain(string trainId) returns record {|TrainInfo bookedTrain;|}|error {
        TrainInfo? selectedTrain = trains.get(trainId);
        if (selectedTrain == null) {
            return error("No train found");
        }
        return {bookedTrain: selectedTrain};
    }
}
