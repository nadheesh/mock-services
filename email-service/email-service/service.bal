import ballerina/http;

type EmailRequest record {|
    string 'from;
    string to;
    string subject;
    string body;
|};

# this is an email service that supporst basic email functionalities
isolated service / on new http:Listener(9090) {

    resource function post sendEmail(EmailRequest payload) returns string {
        return "Email sent successfully to " + payload.'to;

    }
}
