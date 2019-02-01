+++
menutitle = "API Access Control"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# API Access Control

Users access the API using kubectl, client libraries, or by making REST requests. Both human users and Kubernetes service accounts can be authorized for API access. When a request reaches the API, it goes through several stages, illustrated in the following diagram:

![Auth](auth.jpg?class=shadow&width=80pc)

### Authentication

Once TLS is established, the HTTP request moves to the Authentication step. This is shown as step 1 in the diagram.

We use X509 Client Certs for authentication.

When a client certificate is presented and verified, the common name (CN) of the subject is used as the user name for the request.

Client certificates can also indicate a user’s group memberships using the certificate’s organization fields (O).
To include multiple group memberships for a user, include multiple organization fields in the certificate.

While Kubernetes uses `usernames` for access control decisions and in request logging, it does not have a user object nor does it store usernames or other information about users in its object store.

### Authorization

After the request is authenticated as coming from a specific user, the request must be authorized. This is shown as step 2 in the diagram.

A request must include the username of the requester, the requested action, and the object affected by the action. The request is authorized if an **`existing role and role mapping`** declares that the user has permissions to complete the requested action.

### Admission Control

Admission Control Modules are software modules that can modify or reject requests. This is shown as step 3 in the diagram.
In addition to rejecting objects, admission controllers can also set complex defaults for fields.
Once a request passes all admission controllers, it is validated using the validation routines for the corresponding API object, and then written to the object store (shown as step 4).

Example of an [Admission Controller is here](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#alwayspullimages)
