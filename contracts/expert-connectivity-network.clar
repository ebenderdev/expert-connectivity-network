;; Expert Connectivity Network
;;
;; A distributed platform establishing connections between qualified individuals and 
;; enterprises seeking professional expertise in diverse fields of specialization.
;; 
;; Developed for transparent professional engagement and opportunity discovery
;; across multiple industries and geographic regions.


;; ================== DATA PERSISTENCE STRUCTURES ==================

;; Central repository for available professional opportunities
(define-map opportunity-database
    principal
    {
        position-name: (string-ascii 100),
        position-details: (string-ascii 500),
        publisher-identity: principal,
        geographic-territory: (string-ascii 100),
        qualification-requirements: (list 10 (string-ascii 50))
    }
)

;; Central repository for professional talent profiles
(define-map talent-database
    principal
    {
        professional-name: (string-ascii 100),
        qualifications: (list 10 (string-ascii 50)),
        geographic-territory: (string-ascii 100),
        career-background: (string-ascii 500)
    }
)

;; Central repository for business entity information
(define-map enterprise-database
    principal
    {
        business-name: (string-ascii 100),
        business-sector: (string-ascii 50),
        geographic-territory: (string-ascii 100)
    }
)


;; ================== OPERATIONAL CONSTANTS ==================

;; Standard response codes for system operations
(define-constant ERROR-RESOURCE-UNAVAILABLE (err u404))
(define-constant ERROR-TERRITORY-INVALID (err u401))
(define-constant ERROR-EXPERIENCE-INVALID (err u402))
(define-constant ERROR-DUPLICATE-RECORD (err u409))
(define-constant ERROR-QUALIFICATION-INVALID (err u400))
(define-constant ERROR-OPPORTUNITY-INVALID (err u403))
(define-constant ERROR-PROFILE-NONEXISTENT (err u404))


;; ================== PROFESSIONAL PROFILE MANAGEMENT ==================


;; Update existing professional talent profile information
(define-public (update-talent-profile 
    (professional-name (string-ascii 100))
    (qualifications (list 10 (string-ascii 50)))
    (geographic-territory (string-ascii 100))
    (career-background (string-ascii 500)))
    (let
        (
            (profile-owner tx-sender)
            (existing-record (map-get? talent-database profile-owner))
        )
        ;; Verify profile exists before attempting modification
        (if (is-some existing-record)
            (begin
                ;; Validate essential profile information is properly specified
                (if (or (is-eq professional-name "")
                        (is-eq geographic-territory "")
                        (is-eq (len qualifications) u0)
                        (is-eq career-background ""))
                    (err ERROR-EXPERIENCE-INVALID)
                    (begin
                        ;; Update talent profile with most recent information
                        (map-set talent-database profile-owner
                            {
                                professional-name: professional-name,
                                qualifications: qualifications,
                                geographic-territory: geographic-territory,
                                career-background: career-background
                            }
                        )
                        (ok "Professional talent profile successfully updated with new information.")
                    )
                )
            )
            (err ERROR-PROFILE-NONEXISTENT)
        )
    )
)

;; Create new professional talent profile in the network
(define-public (create-talent-profile 
    (professional-name (string-ascii 100))
    (qualifications (list 10 (string-ascii 50)))
    (geographic-territory (string-ascii 100))
    (career-background (string-ascii 500)))
    (let
        (
            (profile-owner tx-sender)
            (existing-record (map-get? talent-database profile-owner))
        )
        ;; Verify unique profile - no duplicate entries allowed
        (if (is-none existing-record)
            (begin
                ;; Validate essential profile information is properly specified
                (if (or (is-eq professional-name "")
                        (is-eq geographic-territory "")
                        (is-eq (len qualifications) u0)
                        (is-eq career-background ""))
                    (err ERROR-EXPERIENCE-INVALID)
                    (begin
                        ;; Record talent profile in persistent storage
                        (map-set talent-database profile-owner
                            {
                                professional-name: professional-name,
                                qualifications: qualifications,
                                geographic-territory: geographic-territory,
                                career-background: career-background
                            }
                        )
                        (ok "Professional talent profile successfully registered in the network.")
                    )
                )
            )
            (err ERROR-DUPLICATE-RECORD)
        )
    )
)

;; ================== OPPORTUNITY MANAGEMENT FUNCTIONS ==================

;; Publish a new professional opportunity listing
(define-public (create-opportunity-listing 
    (position-name (string-ascii 100))
    (position-details (string-ascii 500))
    (geographic-territory (string-ascii 100))
    (qualification-requirements (list 10 (string-ascii 50))))
    (let
        (
            (publisher-identity tx-sender)
            (existing-opportunity (map-get? opportunity-database publisher-identity))
        )
        ;; Verify opportunity listing doesn't already exist for this publisher
        (if (is-none existing-opportunity)
            (begin
                ;; Validate opportunity details meet minimum requirements
                (if (or (is-eq position-name "")
                        (is-eq position-details "")
                        (is-eq geographic-territory "")
                        (is-eq (len qualification-requirements) u0))
                    (err ERROR-OPPORTUNITY-INVALID)
                    (begin
                        ;; Record opportunity listing in persistent storage
                        (map-set opportunity-database publisher-identity
                            {
                                position-name: position-name,
                                position-details: position-details,
                                publisher-identity: publisher-identity,
                                geographic-territory: geographic-territory,
                                qualification-requirements: qualification-requirements
                            }
                        )
                        (ok "Professional opportunity successfully published to network.")
                    )
                )
            )
            (err ERROR-DUPLICATE-RECORD)
        )
    )
)

;; Modify an existing opportunity listing with updated information
(define-public (update-opportunity-listing 
    (position-name (string-ascii 100))
    (position-details (string-ascii 500))
    (geographic-territory (string-ascii 100))
    (qualification-requirements (list 10 (string-ascii 50))))
    (let
        (
            (publisher-identity tx-sender)
            (existing-opportunity (map-get? opportunity-database publisher-identity))
        )
        ;; Verify opportunity listing exists before attempting modification
        (if (is-some existing-opportunity)
            (begin
                ;; Validate opportunity details meet minimum requirements
                (if (or (is-eq position-name "")
                        (is-eq position-details "")
                        (is-eq geographic-territory "")
                        (is-eq (len qualification-requirements) u0))
                    (err ERROR-OPPORTUNITY-INVALID)
                    (begin
                        ;; Update opportunity listing with most recent information
                        (map-set opportunity-database publisher-identity
                            {
                                position-name: position-name,
                                position-details: position-details,
                                publisher-identity: publisher-identity,
                                geographic-territory: geographic-territory,
                                qualification-requirements: qualification-requirements
                            }
                        )
                        (ok "Professional opportunity successfully updated with current information.")
                    )
                )
            )
            (err ERROR-PROFILE-NONEXISTENT)
        )
    )
)

;; Remove an opportunity listing completely from the network
(define-public (remove-opportunity-listing)
    (let
        (
            (publisher-identity tx-sender)
            (existing-opportunity (map-get? opportunity-database publisher-identity))
        )
        ;; Verify opportunity listing exists before attempting removal
        (if (is-some existing-opportunity)
            (begin
                ;; Permanently delete opportunity listing from storage
                (map-delete opportunity-database publisher-identity)
                (ok "Professional opportunity successfully removed from active listings.")
            )
            (err ERROR-PROFILE-NONEXISTENT)
        )
    )
)


;; ================== ENTERPRISE PROFILE MANAGEMENT ==================

;; Create a new enterprise profile in the network
(define-public (create-enterprise-profile 
    (business-name (string-ascii 100))
    (business-sector (string-ascii 50))
    (geographic-territory (string-ascii 100)))
    (let
        (
            (enterprise-identity tx-sender)
            (existing-enterprise (map-get? enterprise-database enterprise-identity))
        )
        ;; Verify enterprise doesn't already have a registered profile
        (if (is-none existing-enterprise)
            (begin
                ;; Validate enterprise profile has all required information
                (if (or (is-eq business-name "")
                        (is-eq business-sector "")
                        (is-eq geographic-territory ""))
                    (err ERROR-TERRITORY-INVALID)
                    (begin
                        ;; Record enterprise profile in persistent storage
                        (map-set enterprise-database enterprise-identity
                            {
                                business-name: business-name,
                                business-sector: business-sector,
                                geographic-territory: geographic-territory
                            }
                        )
                        (ok "Enterprise profile successfully registered in network directory.")
                    )
                )
            )
            (err ERROR-DUPLICATE-RECORD)
        )
    )
)

;; Modify an existing enterprise profile information
(define-public (update-enterprise-profile 
    (business-name (string-ascii 100))
    (business-sector (string-ascii 50))
    (geographic-territory (string-ascii 100)))
    (let
        (
            (enterprise-identity tx-sender)
            (existing-enterprise (map-get? enterprise-database enterprise-identity))
        )
        ;; Verify enterprise profile exists before attempting modification
        (if (is-some existing-enterprise)
            (begin
                ;; Validate enterprise profile has all required information
                (if (or (is-eq business-name "")
                        (is-eq business-sector "")
                        (is-eq geographic-territory ""))
                    (err ERROR-TERRITORY-INVALID)
                    (begin
                        ;; Update enterprise profile with most recent information
                        (map-set enterprise-database enterprise-identity
                            {
                                business-name: business-name,
                                business-sector: business-sector,
                                geographic-territory: geographic-territory
                            }
                        )
                        (ok "Enterprise profile successfully updated with current information.")
                    )
                )
            )
            (err ERROR-PROFILE-NONEXISTENT)
        )
    )
)

;; Remove an enterprise profile completely from the network
(define-public (deactivate-enterprise-profile)
    (let
        (
            (enterprise-identity tx-sender)
            (existing-enterprise (map-get? enterprise-database enterprise-identity))
        )
        ;; Verify enterprise profile exists before attempting removal
        (if (is-some existing-enterprise)
            (begin
                ;; Permanently delete enterprise profile from storage
                (map-delete enterprise-database enterprise-identity)
                (ok "Enterprise profile successfully removed from active directory.")
            )
            (err ERROR-PROFILE-NONEXISTENT)
        )
    )
)

