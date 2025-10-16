# One Login / Teacher Authentication

## Pull Request
https://github.com/DFE-Digital/teacher-success/pull/185

## Objective

To allow users (trainee teachers) visiting the Teacher Success service the ability to sign in to our service.

User's will be able to see details about themselves and their ITT training, such as course, provider, etc.

## OneLogin

### Assumptions

Our original assumption was that we would need to use OneLogin to provide a logged-in experience, aligning with 
the other DfE services. Using OneLogin, we would be able to collect enough data to identify a user. 

Once a user has been identified, we can use that data to collect ITT related information about the user from 
other DfE service.

### Constraints and limitations

#### OneLogin (Authentication)

The OneLogin Authentication strategy will only return the following information regarding a user:
- email address
- id token
- provider (this is the OAuth provider, not the ITT provider)

#### OneLogin (Identify)

The OneLogin Identify strategy will return the following `encrypted` information regarding a user:
- Given name
- Family name
- Birthdate

### Decision

As OneLogin would not be able to provide us with ITT related information about a user, 
we reached out to other DfE services (such as [Apply for teacher training](https://github.com/DFE-Digital/apply-for-teacher-training), 
[Register trainee teachers](https://github.com/DFE-Digital/register-trainee-teachers) and the
[Teaching Record System](https://github.com/DFE-Digital/teaching-record-system)) to see how we could retrieve more 
information about a user, given the information we'd received from OneLogin.

Unfortunately, most these discussions proved fruitless, as the existing APIs for those services are not suitable 
for the needs of our service.

However, during our discussion with the Teaching Record System (TRS) team, we learnt about their upcoming
authentication service for authenticating users and returning personal information and data related to their
teacher training record.

As a result, we decided to move away from the OneLogin implementation, and integrate with Teacher Auth instead.

## Teacher Authentication (Teacher Auth)

[High level flow of signing in to a service that requires authorisation to the teaching record via GOV.UK One Login](https://github.com/DFE-Digital/teaching-record-system/blob/main/docs/trs-gov.one-login-flow.md)

### Assumptions

Using Teacher Auth, we will be able to create a logged-in experience where we can authenticate a user and display their
personal information, and data related to their ITT training and teacher qualifications.

### Constraints and limitations

The Teacher Auth service is still in development, and won't be officially released until mid-December.
However, the Teaching Record System team insist that if we are aiming to use their service to retrieve 
teaching record data, regarding a OneLogin user, we must use their Teacher Auth service.

Due to Teacher Auth requiring a user to have a Teacher Record Number (TRN), user's will only be able to log into the 
service once they have been through the Register process and received their TRN.
Therefore, user's who have just applied for teacher training will not be able to receive a logged in experience.

## Implementation

#### 13 October 2025

The implementation is currently in DEVELOPMENT ONLY.

Working with the TRS team, we have set up a testable integration with the Teacher Auth service, which will
return both personal data and teaching record data regarding a user.

- **omniauth.rb** - The `teacher_auth` omniauth strategy handles requests to the Teacher Auth service. Required keys are stored in the `.env` file.
- **sessions_controller.rb** - Handles the `callback` from the `teacher_auth` omniauth strategy, storing session data and finding or creating a user record.
- **one_login_sign_in_user.rb** - Handles the assignment of session data and finds or creates a user record.
- **teacher_auth/request/user_details.rb** - Decrypts the token containing the users Teaching Record details.
- **user.rb** - Stores basic identifiable user data for use in the Teacher Success service.