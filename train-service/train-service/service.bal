import ballerina/http;
import ballerina/uuid;

type TrainInfo readonly & record {|
    string entryId;
    string startTime;
    string endTime;
    string 'from;
    string to;
    string trainType;
|};

type BookingInfo record {|
    string bookingId;
    string startTime;
    string endTime;
    string 'from;
    string to;
    string trainType;
|};

table<TrainInfo> key(entryId) trains = table [];

isolated service / on new http:Listener(9090) {
    function init() {
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

    # Useful to check for the available trains from a given station to another
    #
    # + 'from - Starting station
    # + to - Destination station
    # + return - List of train information matching the given criteria
    resource function get checkTrains(@http:Query string 'from, @http:Query string to) returns TrainInfo[]|error {
        TrainInfo[] selectedTrains = trains.filter(train => train.'from == 'from && train.to == to).toArray();
        if selectedTrains.length() == 0 {
            return error("No trains found");
        }
        return selectedTrains;
    }

    # Useful to book a train given the train ID
    #
    # + trainScheduleId - ID of the train to be booked
    # + return - Booked train information
    resource function post bookTrain(string trainScheduleId) returns BookingInfo|error {
        TrainInfo? selectedTrain = trains.get(trainScheduleId);
        if selectedTrain == () {
            return error("No train found");
        }

        return {
            bookingId: uuid:createType1AsString(),
            startTime: selectedTrain.startTime,
            endTime: selectedTrain.endTime,
            'from: selectedTrain.'from,
            to: selectedTrain.to,
            trainType: selectedTrain.trainType
        };
    }

    # Useful to get the details of a train given the train ID
    #
    # + trainScheduleId - ID of the train to be retrieved
    # + return - Train information
    resource function get getTrain(string trainScheduleId) returns record {|TrainInfo train;|}|error {
        TrainInfo? selectedTrain = trains.get(trainScheduleId);
        if selectedTrain == () {
            return error("No train found");
        }
        return {train: selectedTrain};
    }

    # Useful to get the details of all the trains
    #
    # + return - List of all the trains
    resource function get getTrains() returns TrainInfo[]|error {
        TrainInfo[] selectedTrains = trains.toArray();
        if selectedTrains.length() == 0 {
            return error("No trains found");
        }
        return selectedTrains;
    }

    # Useful to get the details of all the trains of a given type
    #
    # + trainType - Type of the train to be retrieved
    # + return - List of all the trains matching the given criteria
    resource function get getTrainsByType(@http:Query string trainType) returns TrainInfo[]|error {
        TrainInfo[] selectedTrains = trains.filter(train => train.trainType == trainType).toArray();
        if selectedTrains.length() == 0 {
            return error("No trains found");
        }
        return selectedTrains;
    }

    # Useful to get the details of all the trains of a given time
    #
    # + startTime - Starting time of the train
    # + endTime - Ending time of the train
    # + return - List of all the trains matching the given criteria
    resource function get getTrainsByTime(@http:Query string startTime, @http:Query string endTime) returns TrainInfo[]|error {
        TrainInfo[] selectedTrains = trains.filter(train => train.startTime == startTime && train.endTime == endTime).toArray();
        if selectedTrains.length() == 0 {
            return error("No trains found");
        }
        return selectedTrains;
    }
}
