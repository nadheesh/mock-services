import ballerina/http;

type EmailRequest record {|
    string sender;
    string receiver;
    string subject;
    string body;
|};

# this is an email service that supporst basic email functionalities
isolated service / on new http:Listener(9090) {

    # Useful to send mails to a given receiver
    # + payload - email request payload
    # + return - string with the status of the email sending
    resource function post sendEmail(EmailRequest payload) returns string|error {

        // check for valid email
        if (!payload.receiver.matches(re `^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$`)) {
            return error("Invalid email address given for receiver");
        }
        if (!payload.sender.matches(re `^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$`)) {
            return error("Invalid email address given for sender");
        }
        return "Email sent successfully to " + payload.receiver;
    }
}
