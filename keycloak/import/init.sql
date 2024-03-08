--
-- PostgreSQL database dump
--

-- Dumped from database version 10.17 (Debian 10.17-1.pgdg90+1)
-- Dumped by pg_dump version 14.9 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64)
);


ALTER TABLE public.admin_event_entity OWNER TO keycloak;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO keycloak;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO keycloak;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO keycloak;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO keycloak;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO keycloak;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO keycloak;

--
-- Name: client; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO keycloak;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.client_attributes OWNER TO keycloak;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO keycloak;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO keycloak;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO keycloak;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO keycloak;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO keycloak;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO keycloak;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO keycloak;

--
-- Name: client_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session (
    id character varying(36) NOT NULL,
    client_id character varying(36),
    redirect_uri character varying(255),
    state character varying(255),
    "timestamp" integer,
    session_id character varying(36),
    auth_method character varying(255),
    realm_id character varying(255),
    auth_user_id character varying(36),
    current_action character varying(36)
);


ALTER TABLE public.client_session OWNER TO keycloak;

--
-- Name: client_session_auth_status; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_auth_status (
    authenticator character varying(36) NOT NULL,
    status integer,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_auth_status OWNER TO keycloak;

--
-- Name: client_session_note; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_note (
    name character varying(255) NOT NULL,
    value character varying(255),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_note OWNER TO keycloak;

--
-- Name: client_session_prot_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_prot_mapper (
    protocol_mapper_id character varying(36) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_prot_mapper OWNER TO keycloak;

--
-- Name: client_session_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_role (
    role_id character varying(255) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_role OWNER TO keycloak;

--
-- Name: client_user_session_note; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_user_session_note (
    name character varying(255) NOT NULL,
    value character varying(2048),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_user_session_note OWNER TO keycloak;

--
-- Name: component; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO keycloak;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.component_config OWNER TO keycloak;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO keycloak;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.credential OWNER TO keycloak;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO keycloak;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO keycloak;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO keycloak;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255),
    details_json_long_value text
);


ALTER TABLE public.event_entity OWNER TO keycloak;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024)
);


ALTER TABLE public.fed_user_attribute OWNER TO keycloak;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO keycloak;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO keycloak;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO keycloak;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO keycloak;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO keycloak;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO keycloak;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO keycloak;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO keycloak;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO keycloak;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO keycloak;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL
);


ALTER TABLE public.identity_provider OWNER TO keycloak;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO keycloak;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO keycloak;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO keycloak;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36)
);


ALTER TABLE public.keycloak_group OWNER TO keycloak;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO keycloak;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO keycloak;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL
);


ALTER TABLE public.offline_client_session OWNER TO keycloak;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.offline_user_session OWNER TO keycloak;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO keycloak;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO keycloak;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO keycloak;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO keycloak;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO keycloak;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO keycloak;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO keycloak;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO keycloak;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO keycloak;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO keycloak;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO keycloak;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO keycloak;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO keycloak;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO keycloak;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO keycloak;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO keycloak;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO keycloak;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO keycloak;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode smallint NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO keycloak;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO keycloak;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy smallint,
    logic smallint,
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO keycloak;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO keycloak;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO keycloak;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO keycloak;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO keycloak;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO keycloak;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO keycloak;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL
);


ALTER TABLE public.user_attribute OWNER TO keycloak;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO keycloak;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO keycloak;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO keycloak;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO keycloak;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO keycloak;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO keycloak;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO keycloak;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO keycloak;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO keycloak;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO keycloak;

--
-- Name: user_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_session (
    id character varying(36) NOT NULL,
    auth_method character varying(255),
    ip_address character varying(255),
    last_session_refresh integer,
    login_username character varying(255),
    realm_id character varying(255),
    remember_me boolean DEFAULT false NOT NULL,
    started integer,
    user_id character varying(255),
    user_session_state integer,
    broker_session_id character varying(255),
    broker_user_id character varying(255)
);


ALTER TABLE public.user_session OWNER TO keycloak;

--
-- Name: user_session_note; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_session_note (
    user_session character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(2048)
);


ALTER TABLE public.user_session_note OWNER TO keycloak;

--
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


ALTER TABLE public.username_login_failure OWNER TO keycloak;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO keycloak;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
478786ec-cdd8-4d59-ac93-0860e12d11b9	94d88ef1-3c93-44af-98b0-77908cb42851
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
a3681ee3-5c62-4c33-8e8b-d8d03ce4c69e	\N	auth-cookie	438d433b-f366-40dc-9637-569f7d936a93	393bb45d-51a1-46f6-86f1-b94f85742f4b	2	10	f	\N	\N
61053663-f93a-4016-b538-0cc809459218	\N	auth-spnego	438d433b-f366-40dc-9637-569f7d936a93	393bb45d-51a1-46f6-86f1-b94f85742f4b	3	20	f	\N	\N
fad0a4d6-57cf-45b1-92da-35d2ea271b5e	\N	identity-provider-redirector	438d433b-f366-40dc-9637-569f7d936a93	393bb45d-51a1-46f6-86f1-b94f85742f4b	2	25	f	\N	\N
64391e41-81ee-468f-9ee9-e3088e42b174	\N	\N	438d433b-f366-40dc-9637-569f7d936a93	393bb45d-51a1-46f6-86f1-b94f85742f4b	2	30	t	7db80cd5-abf2-4e0e-83ac-3d7021a1e123	\N
126b8557-3691-4bd2-9b84-da268ab8d8ab	\N	auth-username-password-form	438d433b-f366-40dc-9637-569f7d936a93	7db80cd5-abf2-4e0e-83ac-3d7021a1e123	0	10	f	\N	\N
9676c439-9f09-4c1d-9388-d97f4df8276e	\N	\N	438d433b-f366-40dc-9637-569f7d936a93	7db80cd5-abf2-4e0e-83ac-3d7021a1e123	1	20	t	cea29126-6642-4582-a00f-cbd613518432	\N
3e4677ee-5550-4141-b0fe-704bfaa692e7	\N	conditional-user-configured	438d433b-f366-40dc-9637-569f7d936a93	cea29126-6642-4582-a00f-cbd613518432	0	10	f	\N	\N
82c8c0b9-dfc4-4e47-8022-d9b18c67bc8b	\N	auth-otp-form	438d433b-f366-40dc-9637-569f7d936a93	cea29126-6642-4582-a00f-cbd613518432	0	20	f	\N	\N
39d58584-ada2-4ee7-a491-b907a5b7868c	\N	direct-grant-validate-username	438d433b-f366-40dc-9637-569f7d936a93	2191c7fc-f097-4c93-81cc-6b2b44bc55d4	0	10	f	\N	\N
fb0d8eb1-8462-4216-b82e-4cd3cdc63346	\N	direct-grant-validate-password	438d433b-f366-40dc-9637-569f7d936a93	2191c7fc-f097-4c93-81cc-6b2b44bc55d4	0	20	f	\N	\N
b6c5302d-5c22-4f4b-8f28-232f8b7969f0	\N	\N	438d433b-f366-40dc-9637-569f7d936a93	2191c7fc-f097-4c93-81cc-6b2b44bc55d4	1	30	t	22b4b50a-34bc-4cbe-be1d-ea6210ceb346	\N
a7d911bb-bf98-4b29-84fc-293f85cc148a	\N	conditional-user-configured	438d433b-f366-40dc-9637-569f7d936a93	22b4b50a-34bc-4cbe-be1d-ea6210ceb346	0	10	f	\N	\N
0b6fe0e8-587f-455d-8fce-5c732425f6de	\N	direct-grant-validate-otp	438d433b-f366-40dc-9637-569f7d936a93	22b4b50a-34bc-4cbe-be1d-ea6210ceb346	0	20	f	\N	\N
d3224794-cd7e-4461-a71f-4a1096d26df2	\N	registration-page-form	438d433b-f366-40dc-9637-569f7d936a93	f742377e-5e60-4000-85eb-44d78c56a3fa	0	10	t	ef32b22e-608e-41a9-b718-9621352253d7	\N
732b19ce-4e3a-4788-86d8-8dd2341b506e	\N	registration-user-creation	438d433b-f366-40dc-9637-569f7d936a93	ef32b22e-608e-41a9-b718-9621352253d7	0	20	f	\N	\N
4ae67e23-6501-4591-8e78-43dc10534a35	\N	registration-password-action	438d433b-f366-40dc-9637-569f7d936a93	ef32b22e-608e-41a9-b718-9621352253d7	0	50	f	\N	\N
51348417-55c1-462d-a8ca-53b222f030d9	\N	registration-recaptcha-action	438d433b-f366-40dc-9637-569f7d936a93	ef32b22e-608e-41a9-b718-9621352253d7	3	60	f	\N	\N
32911e9a-2044-456f-8f7c-486e3efea6ed	\N	registration-terms-and-conditions	438d433b-f366-40dc-9637-569f7d936a93	ef32b22e-608e-41a9-b718-9621352253d7	3	70	f	\N	\N
7156ed21-93c6-4ce2-8db8-35faf3a45507	\N	reset-credentials-choose-user	438d433b-f366-40dc-9637-569f7d936a93	2accab68-d7fd-4640-8511-c062c7343c55	0	10	f	\N	\N
d2800e54-41aa-4c8e-acb0-ae36a5b48825	\N	reset-credential-email	438d433b-f366-40dc-9637-569f7d936a93	2accab68-d7fd-4640-8511-c062c7343c55	0	20	f	\N	\N
30075ecf-b6e3-44ca-b7a1-d246b9de9115	\N	reset-password	438d433b-f366-40dc-9637-569f7d936a93	2accab68-d7fd-4640-8511-c062c7343c55	0	30	f	\N	\N
fc401954-eaa1-46d3-b980-1578fa91fd11	\N	\N	438d433b-f366-40dc-9637-569f7d936a93	2accab68-d7fd-4640-8511-c062c7343c55	1	40	t	cbeba2d7-adfd-4be2-b20d-3f7f23bc7136	\N
53117e59-af81-49b9-8346-adf506a78582	\N	conditional-user-configured	438d433b-f366-40dc-9637-569f7d936a93	cbeba2d7-adfd-4be2-b20d-3f7f23bc7136	0	10	f	\N	\N
fbec808b-a2f9-4c11-b22e-d2b613984027	\N	reset-otp	438d433b-f366-40dc-9637-569f7d936a93	cbeba2d7-adfd-4be2-b20d-3f7f23bc7136	0	20	f	\N	\N
0e22d824-c494-4bc3-b572-b8e48efe9b18	\N	client-secret	438d433b-f366-40dc-9637-569f7d936a93	f6babe83-dcab-4576-a90c-46baccec3ce8	2	10	f	\N	\N
9b6ce1c1-d8a1-464d-ab8d-b7c3d271aa24	\N	client-jwt	438d433b-f366-40dc-9637-569f7d936a93	f6babe83-dcab-4576-a90c-46baccec3ce8	2	20	f	\N	\N
fec18d0f-c71c-4b91-a9e2-823539ede75e	\N	client-secret-jwt	438d433b-f366-40dc-9637-569f7d936a93	f6babe83-dcab-4576-a90c-46baccec3ce8	2	30	f	\N	\N
0d73c98a-2c0f-4b63-a35e-4aa056bb4a60	\N	client-x509	438d433b-f366-40dc-9637-569f7d936a93	f6babe83-dcab-4576-a90c-46baccec3ce8	2	40	f	\N	\N
b4938d34-c10e-43cc-8907-6916c38369b4	\N	idp-review-profile	438d433b-f366-40dc-9637-569f7d936a93	abddae97-fc7f-4c52-895b-df74366ca890	0	10	f	\N	0d093e38-7f92-459e-8177-8e68350ad346
707a7df1-b077-471e-a296-483d0946e7ea	\N	\N	438d433b-f366-40dc-9637-569f7d936a93	abddae97-fc7f-4c52-895b-df74366ca890	0	20	t	2fce5593-55e0-4a3d-b485-3a4d05202a96	\N
c8c6f089-7270-445b-b06d-d7062d3427bd	\N	idp-create-user-if-unique	438d433b-f366-40dc-9637-569f7d936a93	2fce5593-55e0-4a3d-b485-3a4d05202a96	2	10	f	\N	cad59b00-0925-467e-ad7b-f80d2424ab30
a4cda5f4-8d45-473a-8d9a-aeee921e3a5d	\N	\N	438d433b-f366-40dc-9637-569f7d936a93	2fce5593-55e0-4a3d-b485-3a4d05202a96	2	20	t	b20da74c-1a85-4cdf-bf01-f8076268dfdd	\N
074333c0-4bdb-4371-a5d8-e6e12b9421dd	\N	idp-confirm-link	438d433b-f366-40dc-9637-569f7d936a93	b20da74c-1a85-4cdf-bf01-f8076268dfdd	0	10	f	\N	\N
75a2d567-828e-4ffa-a5fa-e557084ce77b	\N	\N	438d433b-f366-40dc-9637-569f7d936a93	b20da74c-1a85-4cdf-bf01-f8076268dfdd	0	20	t	7d0a713a-b172-4de4-bac7-2025e9210003	\N
11b6ba38-70c3-4bc3-8d17-105abde90ac6	\N	idp-email-verification	438d433b-f366-40dc-9637-569f7d936a93	7d0a713a-b172-4de4-bac7-2025e9210003	2	10	f	\N	\N
8a3d9882-c981-494d-ac8f-cd3c17e0da9b	\N	\N	438d433b-f366-40dc-9637-569f7d936a93	7d0a713a-b172-4de4-bac7-2025e9210003	2	20	t	0f7dfbf9-2332-48ab-a779-cc0ecdd6f055	\N
90e7b430-11b2-43bf-bba1-d66f201d27fd	\N	idp-username-password-form	438d433b-f366-40dc-9637-569f7d936a93	0f7dfbf9-2332-48ab-a779-cc0ecdd6f055	0	10	f	\N	\N
365a89e4-7292-4d6c-8a59-45fdd1f170f3	\N	\N	438d433b-f366-40dc-9637-569f7d936a93	0f7dfbf9-2332-48ab-a779-cc0ecdd6f055	1	20	t	5644c9a6-60bf-41a6-a208-9650e1d48190	\N
984a2397-9977-4a43-a50e-473c69e7ef30	\N	conditional-user-configured	438d433b-f366-40dc-9637-569f7d936a93	5644c9a6-60bf-41a6-a208-9650e1d48190	0	10	f	\N	\N
16e1417b-81a4-45d5-bb8e-2d612ad81310	\N	auth-otp-form	438d433b-f366-40dc-9637-569f7d936a93	5644c9a6-60bf-41a6-a208-9650e1d48190	0	20	f	\N	\N
0e4af2ee-bb06-4e4f-acaf-afcd36d1ce77	\N	http-basic-authenticator	438d433b-f366-40dc-9637-569f7d936a93	7b85a24c-6c4a-4488-b251-06c971123b61	0	10	f	\N	\N
33eba076-0bf4-471f-81ba-cdb42957be61	\N	docker-http-basic-authenticator	438d433b-f366-40dc-9637-569f7d936a93	1010734e-e783-4034-995b-15ba13aebc1d	0	10	f	\N	\N
6afe2f2c-3659-4740-8f50-1081ce5e8af7	\N	auth-cookie	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	c929bf54-38ff-472b-9dc5-8187f2b0643a	2	10	f	\N	\N
619c6a32-bd02-4b6a-a00c-be3819ce5a75	\N	auth-spnego	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	c929bf54-38ff-472b-9dc5-8187f2b0643a	3	20	f	\N	\N
3856face-a368-4db3-8121-b1449c6d4353	\N	identity-provider-redirector	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	c929bf54-38ff-472b-9dc5-8187f2b0643a	2	25	f	\N	\N
9eb8f7ca-855e-43c3-8fb6-e2697159f770	\N	\N	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	c929bf54-38ff-472b-9dc5-8187f2b0643a	2	30	t	704dcf59-1113-4f59-866d-5a1a71ac0ead	\N
5cdc0c0a-5228-4280-998f-09937b5c7052	\N	auth-username-password-form	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	704dcf59-1113-4f59-866d-5a1a71ac0ead	0	10	f	\N	\N
9b6b308c-4fcd-49c7-929c-3178c0c9d4e1	\N	\N	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	704dcf59-1113-4f59-866d-5a1a71ac0ead	1	20	t	bcfa3988-a4f3-4a31-9020-cf49a5d6ee0f	\N
58e047ea-c664-48a8-8767-f4bf61c35c9d	\N	conditional-user-configured	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	bcfa3988-a4f3-4a31-9020-cf49a5d6ee0f	0	10	f	\N	\N
8e0d52d9-c064-4e90-b1a7-b5754ec83265	\N	auth-otp-form	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	bcfa3988-a4f3-4a31-9020-cf49a5d6ee0f	0	20	f	\N	\N
b967528c-deac-46b6-97b6-88477f63256f	\N	direct-grant-validate-username	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	d64f6d15-326d-4322-a342-11af8b516c1e	0	10	f	\N	\N
8c36bd68-47a0-4108-8368-0c47a21b47e8	\N	direct-grant-validate-password	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	d64f6d15-326d-4322-a342-11af8b516c1e	0	20	f	\N	\N
ede9d44e-68ff-43fc-a698-cc7adafb0fe8	\N	\N	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	d64f6d15-326d-4322-a342-11af8b516c1e	1	30	t	183bf1a5-cc2b-4f1b-9b40-7df233d88d88	\N
f78615c7-21b3-4e8d-b469-dd41f656b605	\N	conditional-user-configured	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	183bf1a5-cc2b-4f1b-9b40-7df233d88d88	0	10	f	\N	\N
cac0994f-0d75-4e74-b5b4-e6708bdc9e06	\N	direct-grant-validate-otp	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	183bf1a5-cc2b-4f1b-9b40-7df233d88d88	0	20	f	\N	\N
f28e298a-d56b-448b-8fbc-c6a2067e72c8	\N	registration-page-form	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	30512607-f784-4a59-bf06-cddbaa5f4735	0	10	t	2f119efb-ee20-4ce7-9b60-5e3c1157bcb7	\N
bec724a2-b35a-4336-8669-81dbe7265b22	\N	registration-user-creation	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	2f119efb-ee20-4ce7-9b60-5e3c1157bcb7	0	20	f	\N	\N
3eb175fa-c1ae-489d-8b6c-3a214cbbda15	\N	registration-password-action	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	2f119efb-ee20-4ce7-9b60-5e3c1157bcb7	0	50	f	\N	\N
0a04557c-b74c-4450-a046-4396b3dc9513	\N	registration-recaptcha-action	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	2f119efb-ee20-4ce7-9b60-5e3c1157bcb7	3	60	f	\N	\N
187fc778-dcfb-4e21-b45a-0a2450a8172c	\N	reset-credentials-choose-user	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	fd2351e2-cc7e-49cf-a403-11cb58e03fce	0	10	f	\N	\N
c53e21b8-3098-47f5-b042-37964f655f7e	\N	reset-credential-email	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	fd2351e2-cc7e-49cf-a403-11cb58e03fce	0	20	f	\N	\N
125ca5f8-ce08-4696-97d6-b0daef10ed04	\N	reset-password	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	fd2351e2-cc7e-49cf-a403-11cb58e03fce	0	30	f	\N	\N
d14ee059-3588-425d-bbdd-81b0c1b19d44	\N	\N	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	fd2351e2-cc7e-49cf-a403-11cb58e03fce	1	40	t	ce3f3541-4922-4680-a48f-52e631adb9d8	\N
bac05733-3f0a-465b-b3db-ee64d31b9c92	\N	conditional-user-configured	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	ce3f3541-4922-4680-a48f-52e631adb9d8	0	10	f	\N	\N
5af125f5-c2f5-466e-ae08-ddeb978f8236	\N	reset-otp	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	ce3f3541-4922-4680-a48f-52e631adb9d8	0	20	f	\N	\N
793f9741-1490-4304-a067-a83114c02070	\N	client-secret	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	7fca25ec-2f81-48ca-b239-241124e5dc4f	2	10	f	\N	\N
162e0162-f4d5-43cd-9e5d-bb5d6cb37e04	\N	client-jwt	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	7fca25ec-2f81-48ca-b239-241124e5dc4f	2	20	f	\N	\N
6d9fb786-da15-4018-b451-5c206e897dd7	\N	client-secret-jwt	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	7fca25ec-2f81-48ca-b239-241124e5dc4f	2	30	f	\N	\N
c7a2b7b0-d7f9-4e1a-81b5-9a01c0a89259	\N	client-x509	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	7fca25ec-2f81-48ca-b239-241124e5dc4f	2	40	f	\N	\N
61e4287e-4a20-4bd8-92ad-00d10848f780	\N	idp-review-profile	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	d5e45495-d5cc-44fd-b71f-9571afa1e3cf	0	10	f	\N	a0e0bff6-008f-4f0e-acba-c9e20d4332a4
a2e13ca1-16cd-4f24-ba08-c384e2b5743f	\N	\N	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	d5e45495-d5cc-44fd-b71f-9571afa1e3cf	0	20	t	737ae7bb-bf5d-41f1-a762-1c1431fa4cc6	\N
395fc3f7-d536-4d32-a9d7-bafb22cbc738	\N	idp-create-user-if-unique	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	737ae7bb-bf5d-41f1-a762-1c1431fa4cc6	2	10	f	\N	a959a7ec-9672-42fd-97d1-fece579b1346
58a02d6f-9af7-4e48-aab2-c49477b49cc2	\N	\N	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	737ae7bb-bf5d-41f1-a762-1c1431fa4cc6	2	20	t	27fd3b47-f37e-466d-9673-d219c7740b2b	\N
9f84e10d-2298-4e9c-9ff9-ac0553f465d5	\N	idp-confirm-link	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	27fd3b47-f37e-466d-9673-d219c7740b2b	0	10	f	\N	\N
6af9827b-a7b8-440a-8b2d-e6d3a0129320	\N	\N	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	27fd3b47-f37e-466d-9673-d219c7740b2b	0	20	t	2c77c065-77c7-46e8-967e-2d5869af8871	\N
4b920987-ddae-403d-8dbf-92b0e64561d3	\N	idp-email-verification	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	2c77c065-77c7-46e8-967e-2d5869af8871	2	10	f	\N	\N
295104df-4efa-4ec5-b9f3-3cbd88076c08	\N	\N	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	2c77c065-77c7-46e8-967e-2d5869af8871	2	20	t	8f3df3e9-19c5-46a1-9a4e-2093a2fd8ae6	\N
81c8517d-c8fa-4839-899e-16ff7b009af5	\N	idp-username-password-form	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	8f3df3e9-19c5-46a1-9a4e-2093a2fd8ae6	0	10	f	\N	\N
c746aa4d-d865-44d4-8709-5901b959187b	\N	\N	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	8f3df3e9-19c5-46a1-9a4e-2093a2fd8ae6	1	20	t	8eaf0e0a-048c-437c-9753-73d7e9f4d2e3	\N
473d5c3e-9ee3-4bcc-8054-e3ce9569e5b1	\N	conditional-user-configured	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	8eaf0e0a-048c-437c-9753-73d7e9f4d2e3	0	10	f	\N	\N
2f512015-9916-4ed8-8e15-1c11696ec7b6	\N	auth-otp-form	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	8eaf0e0a-048c-437c-9753-73d7e9f4d2e3	0	20	f	\N	\N
2af945ee-8248-478b-98fb-caaded710cab	\N	http-basic-authenticator	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	77ffe0e1-e5d4-4bb0-99e9-9213bd984cef	0	10	f	\N	\N
1f654b48-0a62-4178-bc1d-45740f2f48e2	\N	docker-http-basic-authenticator	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	4dace6b7-f326-4a41-ae41-cfc83b6ff9be	0	10	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
393bb45d-51a1-46f6-86f1-b94f85742f4b	browser	browser based authentication	438d433b-f366-40dc-9637-569f7d936a93	basic-flow	t	t
7db80cd5-abf2-4e0e-83ac-3d7021a1e123	forms	Username, password, otp and other auth forms.	438d433b-f366-40dc-9637-569f7d936a93	basic-flow	f	t
cea29126-6642-4582-a00f-cbd613518432	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	438d433b-f366-40dc-9637-569f7d936a93	basic-flow	f	t
2191c7fc-f097-4c93-81cc-6b2b44bc55d4	direct grant	OpenID Connect Resource Owner Grant	438d433b-f366-40dc-9637-569f7d936a93	basic-flow	t	t
22b4b50a-34bc-4cbe-be1d-ea6210ceb346	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	438d433b-f366-40dc-9637-569f7d936a93	basic-flow	f	t
f742377e-5e60-4000-85eb-44d78c56a3fa	registration	registration flow	438d433b-f366-40dc-9637-569f7d936a93	basic-flow	t	t
ef32b22e-608e-41a9-b718-9621352253d7	registration form	registration form	438d433b-f366-40dc-9637-569f7d936a93	form-flow	f	t
2accab68-d7fd-4640-8511-c062c7343c55	reset credentials	Reset credentials for a user if they forgot their password or something	438d433b-f366-40dc-9637-569f7d936a93	basic-flow	t	t
cbeba2d7-adfd-4be2-b20d-3f7f23bc7136	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	438d433b-f366-40dc-9637-569f7d936a93	basic-flow	f	t
f6babe83-dcab-4576-a90c-46baccec3ce8	clients	Base authentication for clients	438d433b-f366-40dc-9637-569f7d936a93	client-flow	t	t
abddae97-fc7f-4c52-895b-df74366ca890	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	438d433b-f366-40dc-9637-569f7d936a93	basic-flow	t	t
2fce5593-55e0-4a3d-b485-3a4d05202a96	User creation or linking	Flow for the existing/non-existing user alternatives	438d433b-f366-40dc-9637-569f7d936a93	basic-flow	f	t
b20da74c-1a85-4cdf-bf01-f8076268dfdd	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	438d433b-f366-40dc-9637-569f7d936a93	basic-flow	f	t
7d0a713a-b172-4de4-bac7-2025e9210003	Account verification options	Method with which to verity the existing account	438d433b-f366-40dc-9637-569f7d936a93	basic-flow	f	t
0f7dfbf9-2332-48ab-a779-cc0ecdd6f055	Verify Existing Account by Re-authentication	Reauthentication of existing account	438d433b-f366-40dc-9637-569f7d936a93	basic-flow	f	t
5644c9a6-60bf-41a6-a208-9650e1d48190	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	438d433b-f366-40dc-9637-569f7d936a93	basic-flow	f	t
7b85a24c-6c4a-4488-b251-06c971123b61	saml ecp	SAML ECP Profile Authentication Flow	438d433b-f366-40dc-9637-569f7d936a93	basic-flow	t	t
1010734e-e783-4034-995b-15ba13aebc1d	docker auth	Used by Docker clients to authenticate against the IDP	438d433b-f366-40dc-9637-569f7d936a93	basic-flow	t	t
c929bf54-38ff-472b-9dc5-8187f2b0643a	browser	browser based authentication	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	basic-flow	t	t
704dcf59-1113-4f59-866d-5a1a71ac0ead	forms	Username, password, otp and other auth forms.	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	basic-flow	f	t
bcfa3988-a4f3-4a31-9020-cf49a5d6ee0f	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	basic-flow	f	t
d64f6d15-326d-4322-a342-11af8b516c1e	direct grant	OpenID Connect Resource Owner Grant	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	basic-flow	t	t
183bf1a5-cc2b-4f1b-9b40-7df233d88d88	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	basic-flow	f	t
30512607-f784-4a59-bf06-cddbaa5f4735	registration	registration flow	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	basic-flow	t	t
2f119efb-ee20-4ce7-9b60-5e3c1157bcb7	registration form	registration form	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	form-flow	f	t
fd2351e2-cc7e-49cf-a403-11cb58e03fce	reset credentials	Reset credentials for a user if they forgot their password or something	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	basic-flow	t	t
ce3f3541-4922-4680-a48f-52e631adb9d8	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	basic-flow	f	t
7fca25ec-2f81-48ca-b239-241124e5dc4f	clients	Base authentication for clients	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	client-flow	t	t
d5e45495-d5cc-44fd-b71f-9571afa1e3cf	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	basic-flow	t	t
737ae7bb-bf5d-41f1-a762-1c1431fa4cc6	User creation or linking	Flow for the existing/non-existing user alternatives	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	basic-flow	f	t
27fd3b47-f37e-466d-9673-d219c7740b2b	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	basic-flow	f	t
2c77c065-77c7-46e8-967e-2d5869af8871	Account verification options	Method with which to verity the existing account	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	basic-flow	f	t
8f3df3e9-19c5-46a1-9a4e-2093a2fd8ae6	Verify Existing Account by Re-authentication	Reauthentication of existing account	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	basic-flow	f	t
8eaf0e0a-048c-437c-9753-73d7e9f4d2e3	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	basic-flow	f	t
77ffe0e1-e5d4-4bb0-99e9-9213bd984cef	saml ecp	SAML ECP Profile Authentication Flow	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	basic-flow	t	t
4dace6b7-f326-4a41-ae41-cfc83b6ff9be	docker auth	Used by Docker clients to authenticate against the IDP	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	basic-flow	t	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
0d093e38-7f92-459e-8177-8e68350ad346	review profile config	438d433b-f366-40dc-9637-569f7d936a93
cad59b00-0925-467e-ad7b-f80d2424ab30	create unique user config	438d433b-f366-40dc-9637-569f7d936a93
a0e0bff6-008f-4f0e-acba-c9e20d4332a4	review profile config	a465077b-0c7f-4fcc-bf69-d3f0805cefe5
a959a7ec-9672-42fd-97d1-fece579b1346	create unique user config	a465077b-0c7f-4fcc-bf69-d3f0805cefe5
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
0d093e38-7f92-459e-8177-8e68350ad346	missing	update.profile.on.first.login
cad59b00-0925-467e-ad7b-f80d2424ab30	false	require.password.update.after.registration
a0e0bff6-008f-4f0e-acba-c9e20d4332a4	missing	update.profile.on.first.login
a959a7ec-9672-42fd-97d1-fece579b1346	false	require.password.update.after.registration
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	f	master-realm	0	f	\N	\N	t	\N	f	438d433b-f366-40dc-9637-569f7d936a93	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
3d9f9d92-d9c3-4841-bac2-53911dd04736	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	438d433b-f366-40dc-9637-569f7d936a93	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
7ef93169-e5b2-4ab7-89a6-7a2a555b443f	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	438d433b-f366-40dc-9637-569f7d936a93	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
542c9876-d5a0-4a9a-bf9a-2756cb92cfab	t	f	broker	0	f	\N	\N	t	\N	f	438d433b-f366-40dc-9637-569f7d936a93	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
d3bccb88-8868-44c1-a6d8-bfa0109aa68d	t	f	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	438d433b-f366-40dc-9637-569f7d936a93	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
ad3083b2-6b35-4ad0-b2ea-dca7e501e8a1	t	f	admin-cli	0	t	\N	\N	f	\N	f	438d433b-f366-40dc-9637-569f7d936a93	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	f	example-realm	0	f	\N	\N	t	\N	f	438d433b-f366-40dc-9637-569f7d936a93	\N	0	f	f	example Realm	f	client-secret	\N	\N	\N	t	f	f	f
aa02c448-ca19-4536-b130-693b671d471d	t	f	realm-management	0	f	\N	\N	t	\N	f	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
b1a916a4-2007-45c9-8319-855c86912a45	t	f	account	0	t	\N	/realms/example/account/	f	\N	f	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
0690e5c3-bdc8-4282-9122-b40b38ac6dcb	t	f	account-console	0	t	\N	/realms/example/account/	f	\N	f	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
a939956d-9f15-43f9-825f-491b8e676e8d	t	f	broker	0	f	\N	\N	t	\N	f	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
98422c57-622e-41c2-874c-22bdf43d32ee	t	f	security-admin-console	0	t	\N	/admin/example/console/	f	\N	f	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
9f738cdd-19ed-4df9-8ddf-4fa6afeda7a6	t	f	admin-cli	0	t	\N	\N	f	\N	f	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
538f0243-e35c-48c0-a255-b7c964a03715	t	t	app	0	f	CzJuCm46nOkw6LRYAAGS7Kgh4fWZ4aqr	http://localhost:8081	f	http://localhost:8081	f	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	openid-connect	-1	t	f	Keycloak	t	client-secret	http://localhost:8081	Example Client	\N	t	f	t	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
3d9f9d92-d9c3-4841-bac2-53911dd04736	post.logout.redirect.uris	+
7ef93169-e5b2-4ab7-89a6-7a2a555b443f	post.logout.redirect.uris	+
7ef93169-e5b2-4ab7-89a6-7a2a555b443f	pkce.code.challenge.method	S256
d3bccb88-8868-44c1-a6d8-bfa0109aa68d	post.logout.redirect.uris	+
d3bccb88-8868-44c1-a6d8-bfa0109aa68d	pkce.code.challenge.method	S256
b1a916a4-2007-45c9-8319-855c86912a45	post.logout.redirect.uris	+
0690e5c3-bdc8-4282-9122-b40b38ac6dcb	post.logout.redirect.uris	+
0690e5c3-bdc8-4282-9122-b40b38ac6dcb	pkce.code.challenge.method	S256
98422c57-622e-41c2-874c-22bdf43d32ee	post.logout.redirect.uris	+
98422c57-622e-41c2-874c-22bdf43d32ee	pkce.code.challenge.method	S256
538f0243-e35c-48c0-a255-b7c964a03715	client.secret.creation.time	1709901176
538f0243-e35c-48c0-a255-b7c964a03715	oauth2.device.authorization.grant.enabled	true
538f0243-e35c-48c0-a255-b7c964a03715	oidc.ciba.grant.enabled	false
538f0243-e35c-48c0-a255-b7c964a03715	post.logout.redirect.uris	+
538f0243-e35c-48c0-a255-b7c964a03715	backchannel.logout.session.required	true
538f0243-e35c-48c0-a255-b7c964a03715	backchannel.logout.revoke.offline.tokens	false
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
64332c2d-d08c-4b27-a2ae-fe83400c473f	offline_access	438d433b-f366-40dc-9637-569f7d936a93	OpenID Connect built-in scope: offline_access	openid-connect
806e1e50-749a-4afe-af19-1885b9a6527e	role_list	438d433b-f366-40dc-9637-569f7d936a93	SAML role list	saml
5c3a75d8-4031-41ca-b7c2-f57016ac6e88	profile	438d433b-f366-40dc-9637-569f7d936a93	OpenID Connect built-in scope: profile	openid-connect
8628575a-2ac6-4af6-9921-b4744adeafdf	email	438d433b-f366-40dc-9637-569f7d936a93	OpenID Connect built-in scope: email	openid-connect
9bb8c391-26a7-4069-b9a7-2c6265738c82	address	438d433b-f366-40dc-9637-569f7d936a93	OpenID Connect built-in scope: address	openid-connect
15e0944d-c431-433e-afc6-720344ab3fe2	phone	438d433b-f366-40dc-9637-569f7d936a93	OpenID Connect built-in scope: phone	openid-connect
e2b5e15d-bcd9-473a-a91c-61a1dfa5450d	roles	438d433b-f366-40dc-9637-569f7d936a93	OpenID Connect scope for add user roles to the access token	openid-connect
39210741-116c-4842-9f99-a3393f95c4a8	web-origins	438d433b-f366-40dc-9637-569f7d936a93	OpenID Connect scope for add allowed web origins to the access token	openid-connect
a6a8e1c1-a62b-48e9-8b38-2cb8fa272747	microprofile-jwt	438d433b-f366-40dc-9637-569f7d936a93	Microprofile - JWT built-in scope	openid-connect
37c3e3aa-47d8-4834-af51-6a46a287e727	acr	438d433b-f366-40dc-9637-569f7d936a93	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
b2fa6c06-6237-47e9-b0fe-1486b60792bd	offline_access	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	OpenID Connect built-in scope: offline_access	openid-connect
ae8cd3ea-c159-4109-a4d5-9a1769991259	role_list	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	SAML role list	saml
fb340605-a470-4668-b6bb-491ffb2b1ab6	profile	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	OpenID Connect built-in scope: profile	openid-connect
ed9f1561-b7c5-4ef4-a123-59413fb97e9e	email	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	OpenID Connect built-in scope: email	openid-connect
d952f795-e55f-4f44-9b01-7afb4e0497c1	address	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	OpenID Connect built-in scope: address	openid-connect
ee481d9d-1f07-44af-bef5-69b4beb1c762	phone	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	OpenID Connect built-in scope: phone	openid-connect
24797bf1-e2a9-45af-b1aa-597dc4a8cbf0	roles	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	OpenID Connect scope for add user roles to the access token	openid-connect
89cb8f94-6c38-4712-a712-d511e9c26fbc	web-origins	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	OpenID Connect scope for add allowed web origins to the access token	openid-connect
5a42ce5e-105b-433f-bd81-8646190ed523	microprofile-jwt	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	Microprofile - JWT built-in scope	openid-connect
cebe2803-77df-4640-b7c1-4a32faa5dd94	acr	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
64332c2d-d08c-4b27-a2ae-fe83400c473f	true	display.on.consent.screen
64332c2d-d08c-4b27-a2ae-fe83400c473f	${offlineAccessScopeConsentText}	consent.screen.text
806e1e50-749a-4afe-af19-1885b9a6527e	true	display.on.consent.screen
806e1e50-749a-4afe-af19-1885b9a6527e	${samlRoleListScopeConsentText}	consent.screen.text
5c3a75d8-4031-41ca-b7c2-f57016ac6e88	true	display.on.consent.screen
5c3a75d8-4031-41ca-b7c2-f57016ac6e88	${profileScopeConsentText}	consent.screen.text
5c3a75d8-4031-41ca-b7c2-f57016ac6e88	true	include.in.token.scope
8628575a-2ac6-4af6-9921-b4744adeafdf	true	display.on.consent.screen
8628575a-2ac6-4af6-9921-b4744adeafdf	${emailScopeConsentText}	consent.screen.text
8628575a-2ac6-4af6-9921-b4744adeafdf	true	include.in.token.scope
9bb8c391-26a7-4069-b9a7-2c6265738c82	true	display.on.consent.screen
9bb8c391-26a7-4069-b9a7-2c6265738c82	${addressScopeConsentText}	consent.screen.text
9bb8c391-26a7-4069-b9a7-2c6265738c82	true	include.in.token.scope
15e0944d-c431-433e-afc6-720344ab3fe2	true	display.on.consent.screen
15e0944d-c431-433e-afc6-720344ab3fe2	${phoneScopeConsentText}	consent.screen.text
15e0944d-c431-433e-afc6-720344ab3fe2	true	include.in.token.scope
e2b5e15d-bcd9-473a-a91c-61a1dfa5450d	true	display.on.consent.screen
e2b5e15d-bcd9-473a-a91c-61a1dfa5450d	${rolesScopeConsentText}	consent.screen.text
e2b5e15d-bcd9-473a-a91c-61a1dfa5450d	false	include.in.token.scope
39210741-116c-4842-9f99-a3393f95c4a8	false	display.on.consent.screen
39210741-116c-4842-9f99-a3393f95c4a8		consent.screen.text
39210741-116c-4842-9f99-a3393f95c4a8	false	include.in.token.scope
a6a8e1c1-a62b-48e9-8b38-2cb8fa272747	false	display.on.consent.screen
a6a8e1c1-a62b-48e9-8b38-2cb8fa272747	true	include.in.token.scope
37c3e3aa-47d8-4834-af51-6a46a287e727	false	display.on.consent.screen
37c3e3aa-47d8-4834-af51-6a46a287e727	false	include.in.token.scope
b2fa6c06-6237-47e9-b0fe-1486b60792bd	true	display.on.consent.screen
b2fa6c06-6237-47e9-b0fe-1486b60792bd	${offlineAccessScopeConsentText}	consent.screen.text
ae8cd3ea-c159-4109-a4d5-9a1769991259	true	display.on.consent.screen
ae8cd3ea-c159-4109-a4d5-9a1769991259	${samlRoleListScopeConsentText}	consent.screen.text
fb340605-a470-4668-b6bb-491ffb2b1ab6	true	display.on.consent.screen
fb340605-a470-4668-b6bb-491ffb2b1ab6	${profileScopeConsentText}	consent.screen.text
fb340605-a470-4668-b6bb-491ffb2b1ab6	true	include.in.token.scope
ed9f1561-b7c5-4ef4-a123-59413fb97e9e	true	display.on.consent.screen
ed9f1561-b7c5-4ef4-a123-59413fb97e9e	${emailScopeConsentText}	consent.screen.text
ed9f1561-b7c5-4ef4-a123-59413fb97e9e	true	include.in.token.scope
d952f795-e55f-4f44-9b01-7afb4e0497c1	true	display.on.consent.screen
d952f795-e55f-4f44-9b01-7afb4e0497c1	${addressScopeConsentText}	consent.screen.text
d952f795-e55f-4f44-9b01-7afb4e0497c1	true	include.in.token.scope
ee481d9d-1f07-44af-bef5-69b4beb1c762	true	display.on.consent.screen
ee481d9d-1f07-44af-bef5-69b4beb1c762	${phoneScopeConsentText}	consent.screen.text
ee481d9d-1f07-44af-bef5-69b4beb1c762	true	include.in.token.scope
24797bf1-e2a9-45af-b1aa-597dc4a8cbf0	true	display.on.consent.screen
24797bf1-e2a9-45af-b1aa-597dc4a8cbf0	${rolesScopeConsentText}	consent.screen.text
24797bf1-e2a9-45af-b1aa-597dc4a8cbf0	false	include.in.token.scope
89cb8f94-6c38-4712-a712-d511e9c26fbc	false	display.on.consent.screen
89cb8f94-6c38-4712-a712-d511e9c26fbc		consent.screen.text
89cb8f94-6c38-4712-a712-d511e9c26fbc	false	include.in.token.scope
5a42ce5e-105b-433f-bd81-8646190ed523	false	display.on.consent.screen
5a42ce5e-105b-433f-bd81-8646190ed523	true	include.in.token.scope
cebe2803-77df-4640-b7c1-4a32faa5dd94	false	display.on.consent.screen
cebe2803-77df-4640-b7c1-4a32faa5dd94	false	include.in.token.scope
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
3d9f9d92-d9c3-4841-bac2-53911dd04736	39210741-116c-4842-9f99-a3393f95c4a8	t
3d9f9d92-d9c3-4841-bac2-53911dd04736	e2b5e15d-bcd9-473a-a91c-61a1dfa5450d	t
3d9f9d92-d9c3-4841-bac2-53911dd04736	37c3e3aa-47d8-4834-af51-6a46a287e727	t
3d9f9d92-d9c3-4841-bac2-53911dd04736	8628575a-2ac6-4af6-9921-b4744adeafdf	t
3d9f9d92-d9c3-4841-bac2-53911dd04736	5c3a75d8-4031-41ca-b7c2-f57016ac6e88	t
3d9f9d92-d9c3-4841-bac2-53911dd04736	a6a8e1c1-a62b-48e9-8b38-2cb8fa272747	f
3d9f9d92-d9c3-4841-bac2-53911dd04736	64332c2d-d08c-4b27-a2ae-fe83400c473f	f
3d9f9d92-d9c3-4841-bac2-53911dd04736	15e0944d-c431-433e-afc6-720344ab3fe2	f
3d9f9d92-d9c3-4841-bac2-53911dd04736	9bb8c391-26a7-4069-b9a7-2c6265738c82	f
7ef93169-e5b2-4ab7-89a6-7a2a555b443f	39210741-116c-4842-9f99-a3393f95c4a8	t
7ef93169-e5b2-4ab7-89a6-7a2a555b443f	e2b5e15d-bcd9-473a-a91c-61a1dfa5450d	t
7ef93169-e5b2-4ab7-89a6-7a2a555b443f	37c3e3aa-47d8-4834-af51-6a46a287e727	t
7ef93169-e5b2-4ab7-89a6-7a2a555b443f	8628575a-2ac6-4af6-9921-b4744adeafdf	t
7ef93169-e5b2-4ab7-89a6-7a2a555b443f	5c3a75d8-4031-41ca-b7c2-f57016ac6e88	t
7ef93169-e5b2-4ab7-89a6-7a2a555b443f	a6a8e1c1-a62b-48e9-8b38-2cb8fa272747	f
7ef93169-e5b2-4ab7-89a6-7a2a555b443f	64332c2d-d08c-4b27-a2ae-fe83400c473f	f
7ef93169-e5b2-4ab7-89a6-7a2a555b443f	15e0944d-c431-433e-afc6-720344ab3fe2	f
7ef93169-e5b2-4ab7-89a6-7a2a555b443f	9bb8c391-26a7-4069-b9a7-2c6265738c82	f
ad3083b2-6b35-4ad0-b2ea-dca7e501e8a1	39210741-116c-4842-9f99-a3393f95c4a8	t
ad3083b2-6b35-4ad0-b2ea-dca7e501e8a1	e2b5e15d-bcd9-473a-a91c-61a1dfa5450d	t
ad3083b2-6b35-4ad0-b2ea-dca7e501e8a1	37c3e3aa-47d8-4834-af51-6a46a287e727	t
ad3083b2-6b35-4ad0-b2ea-dca7e501e8a1	8628575a-2ac6-4af6-9921-b4744adeafdf	t
ad3083b2-6b35-4ad0-b2ea-dca7e501e8a1	5c3a75d8-4031-41ca-b7c2-f57016ac6e88	t
ad3083b2-6b35-4ad0-b2ea-dca7e501e8a1	a6a8e1c1-a62b-48e9-8b38-2cb8fa272747	f
ad3083b2-6b35-4ad0-b2ea-dca7e501e8a1	64332c2d-d08c-4b27-a2ae-fe83400c473f	f
ad3083b2-6b35-4ad0-b2ea-dca7e501e8a1	15e0944d-c431-433e-afc6-720344ab3fe2	f
ad3083b2-6b35-4ad0-b2ea-dca7e501e8a1	9bb8c391-26a7-4069-b9a7-2c6265738c82	f
542c9876-d5a0-4a9a-bf9a-2756cb92cfab	39210741-116c-4842-9f99-a3393f95c4a8	t
542c9876-d5a0-4a9a-bf9a-2756cb92cfab	e2b5e15d-bcd9-473a-a91c-61a1dfa5450d	t
542c9876-d5a0-4a9a-bf9a-2756cb92cfab	37c3e3aa-47d8-4834-af51-6a46a287e727	t
542c9876-d5a0-4a9a-bf9a-2756cb92cfab	8628575a-2ac6-4af6-9921-b4744adeafdf	t
542c9876-d5a0-4a9a-bf9a-2756cb92cfab	5c3a75d8-4031-41ca-b7c2-f57016ac6e88	t
542c9876-d5a0-4a9a-bf9a-2756cb92cfab	a6a8e1c1-a62b-48e9-8b38-2cb8fa272747	f
542c9876-d5a0-4a9a-bf9a-2756cb92cfab	64332c2d-d08c-4b27-a2ae-fe83400c473f	f
542c9876-d5a0-4a9a-bf9a-2756cb92cfab	15e0944d-c431-433e-afc6-720344ab3fe2	f
542c9876-d5a0-4a9a-bf9a-2756cb92cfab	9bb8c391-26a7-4069-b9a7-2c6265738c82	f
e7133bf8-32fa-476a-bddf-d92d4bad00e5	39210741-116c-4842-9f99-a3393f95c4a8	t
e7133bf8-32fa-476a-bddf-d92d4bad00e5	e2b5e15d-bcd9-473a-a91c-61a1dfa5450d	t
e7133bf8-32fa-476a-bddf-d92d4bad00e5	37c3e3aa-47d8-4834-af51-6a46a287e727	t
e7133bf8-32fa-476a-bddf-d92d4bad00e5	8628575a-2ac6-4af6-9921-b4744adeafdf	t
e7133bf8-32fa-476a-bddf-d92d4bad00e5	5c3a75d8-4031-41ca-b7c2-f57016ac6e88	t
e7133bf8-32fa-476a-bddf-d92d4bad00e5	a6a8e1c1-a62b-48e9-8b38-2cb8fa272747	f
e7133bf8-32fa-476a-bddf-d92d4bad00e5	64332c2d-d08c-4b27-a2ae-fe83400c473f	f
e7133bf8-32fa-476a-bddf-d92d4bad00e5	15e0944d-c431-433e-afc6-720344ab3fe2	f
e7133bf8-32fa-476a-bddf-d92d4bad00e5	9bb8c391-26a7-4069-b9a7-2c6265738c82	f
d3bccb88-8868-44c1-a6d8-bfa0109aa68d	39210741-116c-4842-9f99-a3393f95c4a8	t
d3bccb88-8868-44c1-a6d8-bfa0109aa68d	e2b5e15d-bcd9-473a-a91c-61a1dfa5450d	t
d3bccb88-8868-44c1-a6d8-bfa0109aa68d	37c3e3aa-47d8-4834-af51-6a46a287e727	t
d3bccb88-8868-44c1-a6d8-bfa0109aa68d	8628575a-2ac6-4af6-9921-b4744adeafdf	t
d3bccb88-8868-44c1-a6d8-bfa0109aa68d	5c3a75d8-4031-41ca-b7c2-f57016ac6e88	t
d3bccb88-8868-44c1-a6d8-bfa0109aa68d	a6a8e1c1-a62b-48e9-8b38-2cb8fa272747	f
d3bccb88-8868-44c1-a6d8-bfa0109aa68d	64332c2d-d08c-4b27-a2ae-fe83400c473f	f
d3bccb88-8868-44c1-a6d8-bfa0109aa68d	15e0944d-c431-433e-afc6-720344ab3fe2	f
d3bccb88-8868-44c1-a6d8-bfa0109aa68d	9bb8c391-26a7-4069-b9a7-2c6265738c82	f
b1a916a4-2007-45c9-8319-855c86912a45	fb340605-a470-4668-b6bb-491ffb2b1ab6	t
b1a916a4-2007-45c9-8319-855c86912a45	24797bf1-e2a9-45af-b1aa-597dc4a8cbf0	t
b1a916a4-2007-45c9-8319-855c86912a45	cebe2803-77df-4640-b7c1-4a32faa5dd94	t
b1a916a4-2007-45c9-8319-855c86912a45	89cb8f94-6c38-4712-a712-d511e9c26fbc	t
b1a916a4-2007-45c9-8319-855c86912a45	ed9f1561-b7c5-4ef4-a123-59413fb97e9e	t
b1a916a4-2007-45c9-8319-855c86912a45	ee481d9d-1f07-44af-bef5-69b4beb1c762	f
b1a916a4-2007-45c9-8319-855c86912a45	5a42ce5e-105b-433f-bd81-8646190ed523	f
b1a916a4-2007-45c9-8319-855c86912a45	b2fa6c06-6237-47e9-b0fe-1486b60792bd	f
b1a916a4-2007-45c9-8319-855c86912a45	d952f795-e55f-4f44-9b01-7afb4e0497c1	f
0690e5c3-bdc8-4282-9122-b40b38ac6dcb	fb340605-a470-4668-b6bb-491ffb2b1ab6	t
0690e5c3-bdc8-4282-9122-b40b38ac6dcb	24797bf1-e2a9-45af-b1aa-597dc4a8cbf0	t
0690e5c3-bdc8-4282-9122-b40b38ac6dcb	cebe2803-77df-4640-b7c1-4a32faa5dd94	t
0690e5c3-bdc8-4282-9122-b40b38ac6dcb	89cb8f94-6c38-4712-a712-d511e9c26fbc	t
0690e5c3-bdc8-4282-9122-b40b38ac6dcb	ed9f1561-b7c5-4ef4-a123-59413fb97e9e	t
0690e5c3-bdc8-4282-9122-b40b38ac6dcb	ee481d9d-1f07-44af-bef5-69b4beb1c762	f
0690e5c3-bdc8-4282-9122-b40b38ac6dcb	5a42ce5e-105b-433f-bd81-8646190ed523	f
0690e5c3-bdc8-4282-9122-b40b38ac6dcb	b2fa6c06-6237-47e9-b0fe-1486b60792bd	f
0690e5c3-bdc8-4282-9122-b40b38ac6dcb	d952f795-e55f-4f44-9b01-7afb4e0497c1	f
9f738cdd-19ed-4df9-8ddf-4fa6afeda7a6	fb340605-a470-4668-b6bb-491ffb2b1ab6	t
9f738cdd-19ed-4df9-8ddf-4fa6afeda7a6	24797bf1-e2a9-45af-b1aa-597dc4a8cbf0	t
9f738cdd-19ed-4df9-8ddf-4fa6afeda7a6	cebe2803-77df-4640-b7c1-4a32faa5dd94	t
9f738cdd-19ed-4df9-8ddf-4fa6afeda7a6	89cb8f94-6c38-4712-a712-d511e9c26fbc	t
9f738cdd-19ed-4df9-8ddf-4fa6afeda7a6	ed9f1561-b7c5-4ef4-a123-59413fb97e9e	t
9f738cdd-19ed-4df9-8ddf-4fa6afeda7a6	ee481d9d-1f07-44af-bef5-69b4beb1c762	f
9f738cdd-19ed-4df9-8ddf-4fa6afeda7a6	5a42ce5e-105b-433f-bd81-8646190ed523	f
9f738cdd-19ed-4df9-8ddf-4fa6afeda7a6	b2fa6c06-6237-47e9-b0fe-1486b60792bd	f
9f738cdd-19ed-4df9-8ddf-4fa6afeda7a6	d952f795-e55f-4f44-9b01-7afb4e0497c1	f
a939956d-9f15-43f9-825f-491b8e676e8d	fb340605-a470-4668-b6bb-491ffb2b1ab6	t
a939956d-9f15-43f9-825f-491b8e676e8d	24797bf1-e2a9-45af-b1aa-597dc4a8cbf0	t
a939956d-9f15-43f9-825f-491b8e676e8d	cebe2803-77df-4640-b7c1-4a32faa5dd94	t
a939956d-9f15-43f9-825f-491b8e676e8d	89cb8f94-6c38-4712-a712-d511e9c26fbc	t
a939956d-9f15-43f9-825f-491b8e676e8d	ed9f1561-b7c5-4ef4-a123-59413fb97e9e	t
a939956d-9f15-43f9-825f-491b8e676e8d	ee481d9d-1f07-44af-bef5-69b4beb1c762	f
a939956d-9f15-43f9-825f-491b8e676e8d	5a42ce5e-105b-433f-bd81-8646190ed523	f
a939956d-9f15-43f9-825f-491b8e676e8d	b2fa6c06-6237-47e9-b0fe-1486b60792bd	f
a939956d-9f15-43f9-825f-491b8e676e8d	d952f795-e55f-4f44-9b01-7afb4e0497c1	f
aa02c448-ca19-4536-b130-693b671d471d	fb340605-a470-4668-b6bb-491ffb2b1ab6	t
aa02c448-ca19-4536-b130-693b671d471d	24797bf1-e2a9-45af-b1aa-597dc4a8cbf0	t
aa02c448-ca19-4536-b130-693b671d471d	cebe2803-77df-4640-b7c1-4a32faa5dd94	t
aa02c448-ca19-4536-b130-693b671d471d	89cb8f94-6c38-4712-a712-d511e9c26fbc	t
aa02c448-ca19-4536-b130-693b671d471d	ed9f1561-b7c5-4ef4-a123-59413fb97e9e	t
aa02c448-ca19-4536-b130-693b671d471d	ee481d9d-1f07-44af-bef5-69b4beb1c762	f
aa02c448-ca19-4536-b130-693b671d471d	5a42ce5e-105b-433f-bd81-8646190ed523	f
aa02c448-ca19-4536-b130-693b671d471d	b2fa6c06-6237-47e9-b0fe-1486b60792bd	f
aa02c448-ca19-4536-b130-693b671d471d	d952f795-e55f-4f44-9b01-7afb4e0497c1	f
98422c57-622e-41c2-874c-22bdf43d32ee	fb340605-a470-4668-b6bb-491ffb2b1ab6	t
98422c57-622e-41c2-874c-22bdf43d32ee	24797bf1-e2a9-45af-b1aa-597dc4a8cbf0	t
98422c57-622e-41c2-874c-22bdf43d32ee	cebe2803-77df-4640-b7c1-4a32faa5dd94	t
98422c57-622e-41c2-874c-22bdf43d32ee	89cb8f94-6c38-4712-a712-d511e9c26fbc	t
98422c57-622e-41c2-874c-22bdf43d32ee	ed9f1561-b7c5-4ef4-a123-59413fb97e9e	t
98422c57-622e-41c2-874c-22bdf43d32ee	ee481d9d-1f07-44af-bef5-69b4beb1c762	f
98422c57-622e-41c2-874c-22bdf43d32ee	5a42ce5e-105b-433f-bd81-8646190ed523	f
98422c57-622e-41c2-874c-22bdf43d32ee	b2fa6c06-6237-47e9-b0fe-1486b60792bd	f
98422c57-622e-41c2-874c-22bdf43d32ee	d952f795-e55f-4f44-9b01-7afb4e0497c1	f
538f0243-e35c-48c0-a255-b7c964a03715	fb340605-a470-4668-b6bb-491ffb2b1ab6	t
538f0243-e35c-48c0-a255-b7c964a03715	24797bf1-e2a9-45af-b1aa-597dc4a8cbf0	t
538f0243-e35c-48c0-a255-b7c964a03715	cebe2803-77df-4640-b7c1-4a32faa5dd94	t
538f0243-e35c-48c0-a255-b7c964a03715	89cb8f94-6c38-4712-a712-d511e9c26fbc	t
538f0243-e35c-48c0-a255-b7c964a03715	ed9f1561-b7c5-4ef4-a123-59413fb97e9e	t
538f0243-e35c-48c0-a255-b7c964a03715	ee481d9d-1f07-44af-bef5-69b4beb1c762	f
538f0243-e35c-48c0-a255-b7c964a03715	5a42ce5e-105b-433f-bd81-8646190ed523	f
538f0243-e35c-48c0-a255-b7c964a03715	b2fa6c06-6237-47e9-b0fe-1486b60792bd	f
538f0243-e35c-48c0-a255-b7c964a03715	d952f795-e55f-4f44-9b01-7afb4e0497c1	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
64332c2d-d08c-4b27-a2ae-fe83400c473f	4f6dcbf3-e910-4786-9801-de3eaa4a6070
b2fa6c06-6237-47e9-b0fe-1486b60792bd	5c39235a-6e41-4b79-8ea9-5e8a9c4c2427
\.


--
-- Data for Name: client_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session (id, client_id, redirect_uri, state, "timestamp", session_id, auth_method, realm_id, auth_user_id, current_action) FROM stdin;
\.


--
-- Data for Name: client_session_auth_status; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_auth_status (authenticator, status, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_note; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_prot_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_prot_mapper (protocol_mapper_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_role (role_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_user_session_note; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_user_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
0acd0a91-ca72-44bb-880e-223c92b5b54a	Trusted Hosts	438d433b-f366-40dc-9637-569f7d936a93	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	438d433b-f366-40dc-9637-569f7d936a93	anonymous
9a1cc315-3000-44bb-b58c-3a65d0cb0e09	Consent Required	438d433b-f366-40dc-9637-569f7d936a93	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	438d433b-f366-40dc-9637-569f7d936a93	anonymous
234c5d60-4f14-4c54-bbb6-eafe8d8ef7ac	Full Scope Disabled	438d433b-f366-40dc-9637-569f7d936a93	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	438d433b-f366-40dc-9637-569f7d936a93	anonymous
ab86f5a7-a326-4949-914c-f5059d3cf511	Max Clients Limit	438d433b-f366-40dc-9637-569f7d936a93	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	438d433b-f366-40dc-9637-569f7d936a93	anonymous
7d3a8659-f70f-4938-9bb0-9210a48a8ce1	Allowed Protocol Mapper Types	438d433b-f366-40dc-9637-569f7d936a93	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	438d433b-f366-40dc-9637-569f7d936a93	anonymous
ba7e8922-eb46-4521-93b8-8bb211baaebc	Allowed Client Scopes	438d433b-f366-40dc-9637-569f7d936a93	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	438d433b-f366-40dc-9637-569f7d936a93	anonymous
054be969-2b7b-4702-8790-f41c3db06fcb	Allowed Protocol Mapper Types	438d433b-f366-40dc-9637-569f7d936a93	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	438d433b-f366-40dc-9637-569f7d936a93	authenticated
76b2519c-f341-44db-8a97-657a1bf1c0ce	Allowed Client Scopes	438d433b-f366-40dc-9637-569f7d936a93	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	438d433b-f366-40dc-9637-569f7d936a93	authenticated
03e5028f-d42f-4eb9-8696-9d8dd9e177e0	rsa-generated	438d433b-f366-40dc-9637-569f7d936a93	rsa-generated	org.keycloak.keys.KeyProvider	438d433b-f366-40dc-9637-569f7d936a93	\N
50e3716b-a404-490b-8d53-93836ca72624	rsa-enc-generated	438d433b-f366-40dc-9637-569f7d936a93	rsa-enc-generated	org.keycloak.keys.KeyProvider	438d433b-f366-40dc-9637-569f7d936a93	\N
41b287e5-8b64-49a5-b316-fefdee52d736	hmac-generated	438d433b-f366-40dc-9637-569f7d936a93	hmac-generated	org.keycloak.keys.KeyProvider	438d433b-f366-40dc-9637-569f7d936a93	\N
0187459e-ee52-4906-8176-27eb0aec3047	aes-generated	438d433b-f366-40dc-9637-569f7d936a93	aes-generated	org.keycloak.keys.KeyProvider	438d433b-f366-40dc-9637-569f7d936a93	\N
5014ab17-979a-4f93-b308-3db48c1187c6	rsa-generated	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	rsa-generated	org.keycloak.keys.KeyProvider	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	\N
f0c422ff-315c-4378-8cb1-3a917ecdd7eb	rsa-enc-generated	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	rsa-enc-generated	org.keycloak.keys.KeyProvider	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	\N
785e5277-b175-4979-9c96-8bc77cc7ebe4	hmac-generated	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	hmac-generated	org.keycloak.keys.KeyProvider	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	\N
4d83c500-7417-4303-b51b-c09b0801e1c8	aes-generated	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aes-generated	org.keycloak.keys.KeyProvider	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	\N
fc2edc58-87b7-4aff-9825-bac6f0d58578	Trusted Hosts	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	anonymous
91eb2416-e790-4d93-915b-017bfadb4670	Consent Required	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	anonymous
67d519be-95ba-4601-b131-9b88f9098309	Full Scope Disabled	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	anonymous
f83f6690-f29a-4c82-932d-07a69922b533	Max Clients Limit	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	anonymous
9395165d-75e5-4be3-86a3-60f7672d3e5e	Allowed Protocol Mapper Types	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	anonymous
f793f2ec-2fec-455f-aa82-725b41f8eabd	Allowed Client Scopes	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	anonymous
cc5d8818-2e25-4f3a-b29d-34cd84a3e850	Allowed Protocol Mapper Types	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	authenticated
37df9d49-c0fb-4057-80dc-80f868bd4b60	Allowed Client Scopes	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	authenticated
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
fa5ad003-18aa-4004-b5e5-88376cca7098	ba7e8922-eb46-4521-93b8-8bb211baaebc	allow-default-scopes	true
c7e15a78-99d2-4255-b591-086319b4b57a	0acd0a91-ca72-44bb-880e-223c92b5b54a	client-uris-must-match	true
a06087d8-4156-47ac-a168-eea7b06f90cf	0acd0a91-ca72-44bb-880e-223c92b5b54a	host-sending-registration-request-must-match	true
9c8a7dbd-0e7f-4555-aa78-11141645f074	76b2519c-f341-44db-8a97-657a1bf1c0ce	allow-default-scopes	true
a3f04a6e-dc91-44ea-8567-cce2c2424a68	ab86f5a7-a326-4949-914c-f5059d3cf511	max-clients	200
8298c00a-5d0c-49e5-bb00-78f5f4621d42	7d3a8659-f70f-4938-9bb0-9210a48a8ce1	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
91c93e10-3ad0-4e73-8b92-d963f2672e01	7d3a8659-f70f-4938-9bb0-9210a48a8ce1	allowed-protocol-mapper-types	oidc-full-name-mapper
66f90b7d-ac92-452a-9a73-8b0bbe7a6fee	7d3a8659-f70f-4938-9bb0-9210a48a8ce1	allowed-protocol-mapper-types	saml-user-property-mapper
7ca1d011-55ed-4dd3-a443-2dcd7e4c4b36	7d3a8659-f70f-4938-9bb0-9210a48a8ce1	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
1ee5b923-9c64-4205-b043-ec71293656d9	7d3a8659-f70f-4938-9bb0-9210a48a8ce1	allowed-protocol-mapper-types	oidc-address-mapper
076eca2c-cb12-44e9-adb5-c747cce7bb15	7d3a8659-f70f-4938-9bb0-9210a48a8ce1	allowed-protocol-mapper-types	saml-role-list-mapper
de91d9f7-3252-43f4-bcdb-397c5b2eb729	7d3a8659-f70f-4938-9bb0-9210a48a8ce1	allowed-protocol-mapper-types	saml-user-attribute-mapper
5c3c0d87-b8f5-4519-81e3-68a675465488	7d3a8659-f70f-4938-9bb0-9210a48a8ce1	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
7032546e-bfae-4dfb-a1da-b14423a25edb	054be969-2b7b-4702-8790-f41c3db06fcb	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
202e73b7-b7f5-4333-bcf8-8e327dfde742	054be969-2b7b-4702-8790-f41c3db06fcb	allowed-protocol-mapper-types	saml-user-attribute-mapper
09d409b5-cfbf-4025-893c-5623e86fa75b	054be969-2b7b-4702-8790-f41c3db06fcb	allowed-protocol-mapper-types	oidc-address-mapper
3bb6e054-46b5-40f5-8d20-2ca929540bae	054be969-2b7b-4702-8790-f41c3db06fcb	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
0df283ea-368a-4649-9f51-198bff1cf2f5	054be969-2b7b-4702-8790-f41c3db06fcb	allowed-protocol-mapper-types	saml-role-list-mapper
eef890de-6fe4-4eee-b6f6-8814fc06caec	054be969-2b7b-4702-8790-f41c3db06fcb	allowed-protocol-mapper-types	saml-user-property-mapper
9cb8fffd-a313-4194-bcf4-6c0982e502dd	054be969-2b7b-4702-8790-f41c3db06fcb	allowed-protocol-mapper-types	oidc-full-name-mapper
c282a0b4-8d1e-4745-b04e-0a435e2d26c7	054be969-2b7b-4702-8790-f41c3db06fcb	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
9199a987-9dbe-44c1-8a5d-1ff81b4f05f6	03e5028f-d42f-4eb9-8696-9d8dd9e177e0	certificate	MIICmzCCAYMCBgGOHgrb7zANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjQwMzA4MTIyODMxWhcNMzQwMzA4MTIzMDExWjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCOFMRqqQ3BbcGXEXnHrmtNb9/E9LKUlTUdP2s+LjKWYzUv0SUlRzUiKFVNDa7Rbfy70/PFambkM/VEMJ/h+z95f3OMZ5pbjiekhpJhXMb912Ekq+mkHOT9UjQXGv4bBAUn8senhC8F5683vFkTnyzi8ILk3GZbrG2hA2ez9oiH2uQdgAtllmr66KL+XhOc6NOcy52WBYIBGIkw5MympM6JvR1M7fhd5HevPMrW7PBZVhzr2ADUCLnROTFtP3HBPIrH/bTHfKcfsDvkdSxeBkr06IM78M42gWZ2gJMQgZCgHxmJsA6oHeomyKZORasaRDpyl7+NzkbzO0wRH+diLIbDAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAB4aTkGLVP0LSyCpT2gAxnVr4GCnHF04esGRAJ9J3TOZhQNSf4Ma+EZJ502MhxQQPqwBEHI8Ons+Wvr3PbmNMoFc8jRXALoF0+7qg2ZFzn2pZuD0VQVoAXjghkv5wAFO6W62dCOJYhOc4lO7F8gcW/qlz2ya8wzPreLUwXSlKXYStj3h2zPLqdgV8L4AMyONpgxXVx03VKUIowEeKONIcAh51H3srpFBA1CXPQsr+bSh+q8xm/iTgRvDPsyzdOjw49wQqBHvT5goUPfsRtMP3Z4KTaal17y6Xch55X+H1RLp76VKhog36+nqiHttZSfziVdElVYKSD4wKCFqqsiU65E=
f7846955-ad6d-47cc-9ab6-70fb2499f7f6	03e5028f-d42f-4eb9-8696-9d8dd9e177e0	keyUse	SIG
710ff376-8a13-4627-8a5b-d8bce00064b7	03e5028f-d42f-4eb9-8696-9d8dd9e177e0	privateKey	MIIEowIBAAKCAQEAjhTEaqkNwW3BlxF5x65rTW/fxPSylJU1HT9rPi4ylmM1L9ElJUc1IihVTQ2u0W38u9PzxWpm5DP1RDCf4fs/eX9zjGeaW44npIaSYVzG/ddhJKvppBzk/VI0Fxr+GwQFJ/LHp4QvBeevN7xZE58s4vCC5NxmW6xtoQNns/aIh9rkHYALZZZq+uii/l4TnOjTnMudlgWCARiJMOTMpqTOib0dTO34XeR3rzzK1uzwWVYc69gA1Ai50TkxbT9xwTyKx/20x3ynH7A75HUsXgZK9OiDO/DONoFmdoCTEIGQoB8ZibAOqB3qJsimTkWrGkQ6cpe/jc5G8ztMER/nYiyGwwIDAQABAoIBABKh6ZI9QkcMEDex/IDxwDOjCLrpBiRTHuiLgRJh95NeRkLTkCX/3RlyJaGZukPPwzWUmaLZjc2+fJspL0Zw7wWNb8dJbOY10cATP84R3yy52oz3GIhDm8oWxisDiLBdShnPjlxLCumg1QsfoaTfmoDWXqwJtUivZ58WdbqViZkbKvvuj3QmVbKSnHudtTD4UENYo2xNDiPfcvhHtVCBzOrBfP2szJdCWBWlnH+p38CH549/OWtbbW3gtTe/6shm+nK95VJLQE3mOUUbmL86PAqJnyLrbzkl1f6aNFiXP4/O0SoxNrw2Hxw34r3klhjXojF9o0tEU+RslNR9mkXEZfECgYEAyBG1v8w4AcC+PaX5AlNj44oRML6HNlFMQfX63OTNNzzAnq/jtdB+wclTpJuNGV0xnmGNk5OzQ8h1vd93mVCIset1i8cpLzTreIQCb9zyYsmZc/qq8mWVJSDz4P6zZo5u4i0uetT1H0PCe6N6oVc1PI7D9f5iT/hJJQSPIYKxwbMCgYEAtc0LLHdI0gTS3drLXC4V9hXUNlWUiHQLKYazQriXC8OkxBm3uoQEOVic2M8D0SJ87XugljC+wz8id6pmxTQb6SIaVeJE8dBVDw3p7mqtynL0k/PbDhA/R+OYbtj4SvOjK6t9GMOhRPEVW+VbxV/RaDlZbkwZw6K/t2g8RpWS/rECgYARw5jKpdxXM4DwwlrgvPzCiFDMbi5dQUyvEqMql9oszGUh8eYbD58hn7mghPs7RE4SjQDgGJ4zJ4pkyIG7CC6K9agjOBTNDzrVIYuB2TFgWhwY8ynYifJ7MHjXAmZ1dbIcvPxChcQZ+Y88ISDTUIX2kYqOvf6GsTn1Ynk+9XbJBwKBgQCv2Fp8cgxvh9bmXCDjUnhPhKG0xGZc7dF2IyH04VLIQD54p198+wCS71EWrHXGrZMkqbWUUCXT+JdAJAQvrs1oXGIYvDlvo9ECNLUWtPzQmwxSp0Y0fiaXRF9GqHrRFIO5U7A2adLtOjssndZ8PMfyBbao5tbs0diacCoNI9QAoQKBgErOVBYpMNcUBWPAPLUKCVAY8Ivgnekr0rBlMJVbz2SgkOiCjP86dF8+8hIJb6da/oUx6nQOOgoK64uvw21/UZmnFf4mclN6zAqm5l7st40dlC2jIIyJRi75d+7Eb6uZUpLiArek0CRh7aSdJC4ysruSiu/lzStihJ79MjQObcmS
3c7e734c-7c5f-4756-8949-4558ba40a966	03e5028f-d42f-4eb9-8696-9d8dd9e177e0	priority	100
d9997635-a33d-43eb-805d-786eb7f17eb2	50e3716b-a404-490b-8d53-93836ca72624	privateKey	MIIEowIBAAKCAQEAr0FE2IbVRgwCNDAMfdREeE6Ds+ljkMggOwhwdxGjzNJt23VsS1rxIGxaF+eNTgp+WuYkjSNTGtKkESpxV4S5EQ0J69GvVzo8kTT4u9itQ5N1SX/vhNT5Qke9V99e/T5tI2X+fm5soZ0f1xaP81rvr5i0kqGzsIy7oJ01IpAfhSZ6usRxXvbT1Us9A9DoVuy5sA1W0A3jRyEuS/KYRgAY8D5bWufbq4sGJfV+FZAcQE7XF52e52L0ECzg6pTi68qZzxJgN3vZOMmGj+ATN21oEoWCNSf64SlS78lkXB3goP0cf51JleHDItzxRsGVyn9wJqiAwghWPEtkKZ82w/nhDwIDAQABAoIBAATCjRAkeV5xrQ2l0HEKduGdoE4epKmmBdoUnJlfTUee34T6Z3qUecAbsUa870WTW2M0pQGAWB1+Yx5kPLfXzv77j61sAIsp9cMr4SWY+PvA4YqhguvkrPBz6lycoIPYUjaH6qWcci7hiZ/Z6Qb/DUuDpkPlSHAfIml2W58YswJ2wYfw32ysJCCStOonTaKE9j/BHr0j6Cmq4rWrEfFc37x50thN4wgH7is78vb+MB04n4l/vqXxQyirokEExr6N2Y8DxPM23CTgIzNCzZcmVVf2wShWY6DIl9D0JLu6bZw9TPMOEgScbKxdcFvVQz74qvrEDKeRc7i/WT8oJiKyPWECgYEA6MSda3B+ELuadlmjzGekmEe67NqkLdhvGrIIYPtzyC42GPZLpNQsbBIllsmcZEkDHUo4r+vaC00JX6UVGM9DtrC2rHKlzk0R5QIkB+2eWVgrOUbkVpui7WOlZPeeCjoFIhW2VeklwG5suJNpd1tWy4D1eBEtWf9JhUVacanU0ysCgYEAwL8nsJFWtJ2Y+b20VKAYRYwUgBHL5PRMMpY1DvWTotQ3h7Iq+rx7DK2uy9XaiODA+Vpw/kXCR2fXuPraJIbeUEwwj6wgWJ8qGd+2Kzki+kNBYvLugUxlhPcmDl5KuBqc6a3tICk4FiadkIkdkpt3wFeZzhEzGvy1pZQalqujB60CgYEAhVzpSL56LEIgnMB9PccAIhOvALfAq1e/SI9Kh65qRv5bFnA/JOA/12eKS9uVlEvU0fpNglXiZukrfrZJ4R4XkNusvh8t6oZzwz83v6cgO9ZtZXK9rvWbIuIdyDyrOvbFLCM+hfiAHcHm3tXu7mjR0OVBPxqwXkkLKaVzzX3dp2MCgYBJcMxjp40c9quSBOlQEUwOO8iX37ALxdW+tKL01zdwpGGgL4/Wx7gu5YKjohFJdDGzEPXavKPA510320UBA+5zNASQyanten/lKetUXsnoB3ZDiIK9+2j3F+CFOwJHUcSV+TJPvcTkE8SXjNcaxGgFfptY/A636rAfreXPoQhWZQKBgBrAyTVXqoFn2PCbZP06anobwmW4ER1sJSjPzdTNv/Ue90OebXG3cNg2Lc0kaNFMHum166ujIsCM6urtb3er985n3iKmsT0IuDI2ZcQd6VZsxD+WVJXJf7p9/iv19XNsTcxZV39XnztLwHEYtRO6QMV+oRJ01TywdArUwFPVZgCO
7a12e2c6-960e-4bc8-8e7b-68ed939ed6f4	50e3716b-a404-490b-8d53-93836ca72624	algorithm	RSA-OAEP
79b8a311-8b46-4b46-ab6d-379141d3d882	50e3716b-a404-490b-8d53-93836ca72624	certificate	MIICmzCCAYMCBgGOHgrcyDANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjQwMzA4MTIyODMyWhcNMzQwMzA4MTIzMDEyWjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvQUTYhtVGDAI0MAx91ER4ToOz6WOQyCA7CHB3EaPM0m3bdWxLWvEgbFoX541OCn5a5iSNI1Ma0qQRKnFXhLkRDQnr0a9XOjyRNPi72K1Dk3VJf++E1PlCR71X3179Pm0jZf5+bmyhnR/XFo/zWu+vmLSSobOwjLugnTUikB+FJnq6xHFe9tPVSz0D0OhW7LmwDVbQDeNHIS5L8phGABjwPlta59uriwYl9X4VkBxATtcXnZ7nYvQQLODqlOLrypnPEmA3e9k4yYaP4BM3bWgShYI1J/rhKVLvyWRcHeCg/Rx/nUmV4cMi3PFGwZXKf3AmqIDCCFY8S2QpnzbD+eEPAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAIc52/vIGaqRggxobwRyehXoPDaQE3tKzcZPsW1UsL9rvZD7VLY3FCeU+rADvzNGF315KyjI5U2bp4CTOchhnjGZ+fMJfw0fCVhiSkhMlXCp8hpEdVIRuaKgizaWcUU9mBd7AjXgNz3dVyJ75sL0WuQpKHQ5NYCRwNK03FI9wwVCbiWkD4E/RqtPjidY3lMjtulKxurtBsWWbjSahMIsM9jXox/RHd4ChhcHZcqN/oFg3ZLL6mxN6t84n2qJnRTeEUD98V1sTO9S9nvuM6AohMUlOn79hgjWL+GdQLAxXZjkip+IfvjL4laIxswgbP8oBTMVD7eFKkH+dugVMzzFfOA=
1503b2eb-3c27-47c1-bcb7-5211396fd023	50e3716b-a404-490b-8d53-93836ca72624	keyUse	ENC
0edb17ed-eb7b-4608-a7da-bc71f4e911b1	50e3716b-a404-490b-8d53-93836ca72624	priority	100
ea819b03-15e7-4a9f-af56-2d6b7fd16ba7	0187459e-ee52-4906-8176-27eb0aec3047	secret	WWFw7Vta9uzsFPjcjDBbuA
7b17bb7a-3d9f-4b64-b161-4d1815462bd5	0187459e-ee52-4906-8176-27eb0aec3047	priority	100
8ddd871b-c811-4da7-8284-4af4825a12e1	0187459e-ee52-4906-8176-27eb0aec3047	kid	d099515b-06f3-420e-aad3-13835bd35a1d
eb9f77a9-b483-46b1-b24d-82c0d1156731	41b287e5-8b64-49a5-b316-fefdee52d736	secret	xkDnYkqAK5e-3_ZEU2_uyM_cjrAhX_xukptlO0PJeDm1eiK7HU-xW_kpPeG68ICmqTxk2DUYreMxfQp662_Pnw
ebcf276c-f907-4ea3-ae7d-faa0a7c75762	41b287e5-8b64-49a5-b316-fefdee52d736	kid	1723f760-360c-4e4e-bb65-7d631c581e5a
1e37fb5f-5ca3-4fdb-a0fc-99f845bb52d7	41b287e5-8b64-49a5-b316-fefdee52d736	priority	100
e271ba48-5b80-460f-a6f0-93018642c0bc	41b287e5-8b64-49a5-b316-fefdee52d736	algorithm	HS256
b7546ab7-259a-493b-b071-0d91dbc4e964	4d83c500-7417-4303-b51b-c09b0801e1c8	kid	ce683267-63d6-497a-b75e-595af85f2439
28abe32a-c307-44b2-9190-5514bf15a151	4d83c500-7417-4303-b51b-c09b0801e1c8	priority	100
7848d575-946d-4f16-896e-bc58c568c881	4d83c500-7417-4303-b51b-c09b0801e1c8	secret	iao7qw-sMXbFatwNCU4Yzw
ac0c5ad8-f106-4d5d-9c89-2e808a539b44	785e5277-b175-4979-9c96-8bc77cc7ebe4	algorithm	HS256
1a06d94f-5bed-4201-bf34-e96f31d93e46	785e5277-b175-4979-9c96-8bc77cc7ebe4	kid	8a58a96d-ee9f-4d4b-b5df-d1b493cdfa1e
d02cf299-be28-4ba5-a066-6edbf32907cd	785e5277-b175-4979-9c96-8bc77cc7ebe4	priority	100
f576fe34-c8e8-4ac9-834a-df3ed9c14224	785e5277-b175-4979-9c96-8bc77cc7ebe4	secret	ksNNfYnf4nDQu3wGLC1BB1Cdy3UeEBV80VW6HgPPb2OxWPBle_oszU4BLMZnhTh_n_P3Xo9R2KGF3t4vWyV4dw
f97bdd44-04b2-4f6a-9bd7-1e73681acd44	f0c422ff-315c-4378-8cb1-3a917ecdd7eb	keyUse	ENC
8977d977-f451-4d19-b4cb-ea556ad6f174	f0c422ff-315c-4378-8cb1-3a917ecdd7eb	priority	100
a293c124-19fb-4a17-8939-81214f09d2da	f0c422ff-315c-4378-8cb1-3a917ecdd7eb	privateKey	MIIEowIBAAKCAQEAqeljBiym96zyTlYZZ5pPldQ7pyioPC4fxP1IeDrC6stxOCSZKPh3YAho4a881PRIivZmyzCb0touSYNHzgwr8QVQk2GiM8J9KPI86vBIyz4ivTiWxNT1oqTa4xGropYo0uf+7Bwif5qMjDlgnYs0trMneH2bs2mPdvs/pC4SPbpXMTtPp74enRZ/FhCZXTyypvJhavolb1B7zcAqfN1Pg5Zc3zR0CxgNH+A8cZnKHaYGIpgVhomXS0xB9uSzGTR+4nqEdABY4HxWxDgOauWRb7dsoVNt3i0O6PIbglZjXMCvC/rt6ARmVoiYpzsx5Zxj7AZYiBgxgeQum/vn03X3EwIDAQABAoIBABAwMEMSVgYa8CsOgPUh+psn0VcnxH+XVWeLSjBKSO/d2jejJQSGR7lak8OM0prne1HiEAEj7HS2XNqcK2cyOa2I+BhSoQWVbh9MlQk9Q3I5xU2J6rNuJskMM96WfGfNLq6Jc/xC4faOXv2tKctYy/jsMMKGFSOO1yBa58FYslw3EPmomI2O9U8HDK83fL6PHfEQ7xlONVjmzHyr6ODZs9vlkj2LEeLAfVqdYqUZz73VyXleKe7h0OCVq3/SoyZD40EF5m1zrx2MNx8JweJcRScprytiZ6i1HLUmAuYMtuQU0xL2duYo8VOYWVXrJKkxf5ZT//LrofWnh0PdRjocLYECgYEA2Q+ISx9Wf2ovCMzodqpddR8E6A/9twdE5U4Xg/g1RoMWJnzN6ZIewxUAtXKKNW8+QDkKWk6Efxd/hwi3MFn4wMFl0TpXGhBU7EZJmSMPfNIL8+h4AW0CqV5v3d9WUvRPy77T0/pHr1xfMqqCUWPlyn24d/hR2buNW2OnYzVXL4MCgYEAyGSLu004w9pUsjdGJg8LVcuKaa8QKoxIX77IEw2nBagMLbqT095kDBaRk6+q2hERs+hBqkjCB4pJM2hErS9ydJ77y4X/Uh1CnLSrrGEA52A36/fufIzZfOZmW/lHXUpG8G4NmvgTU5KcUorjaRpObdCOPB3QT4WpxSQi57KFdTECgYAVlaLS/ZHHZ9K3iFDRhA15GRWO0hBDxBhIySQzflol4eExAJYlVN90PMFuSa6Os7o3/rQV2Nr6HGcVEXvN9hRzbofmb2u77sXTHQYykTb4DZccsRBF7AYou3haUtwtsZfBxf8ghDHesUvSKPx+hXWTVj8ixvG0uh7LaLR7fBFoawKBgFqddL4enjOaD8CC1BqzpNmH76/4dKP4yWVaPNi4zLT3F4K6IsykfLMmpW+V+PkgzNOAi+j3e52zP4Saequhj+0CUzPmBN1Z09xOqm6JcsIttTvj4hi6DEK5YMHoSAf8ZXWlHkvcL8kTu9JrcYf+WEa6DwdKJ/89ntZBj/Mbu9ORAoGBALORE7MzGMZ+JaI3idjiZBaPPNnlEjywPewU8AWNYhMcJlK0Cjiq7wyCNRiaZsOr/7jiG5EULzS4+VTlEdSs+TX76V1hIItNaS5VXAgShcC0AXbgEAUJny8YcUbCyf2xVTtaZQqDD6qGzYj05jWjngDTK3joe4TQZtXtRZIdTgBJ
1faa1fa2-a7da-459f-9d8e-3f9067bdaafd	f0c422ff-315c-4378-8cb1-3a917ecdd7eb	algorithm	RSA-OAEP
e2df1754-3453-4bb7-afe9-ab740a77ed8d	f0c422ff-315c-4378-8cb1-3a917ecdd7eb	certificate	MIICnTCCAYUCBgGOHgs3fTANBgkqhkiG9w0BAQsFADASMRAwDgYDVQQDDAdleGFtcGxlMB4XDTI0MDMwODEyMjg1NVoXDTM0MDMwODEyMzAzNVowEjEQMA4GA1UEAwwHZXhhbXBsZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKnpYwYspves8k5WGWeaT5XUO6coqDwuH8T9SHg6wurLcTgkmSj4d2AIaOGvPNT0SIr2Zsswm9LaLkmDR84MK/EFUJNhojPCfSjyPOrwSMs+Ir04lsTU9aKk2uMRq6KWKNLn/uwcIn+ajIw5YJ2LNLazJ3h9m7Npj3b7P6QuEj26VzE7T6e+Hp0WfxYQmV08sqbyYWr6JW9Qe83AKnzdT4OWXN80dAsYDR/gPHGZyh2mBiKYFYaJl0tMQfbksxk0fuJ6hHQAWOB8VsQ4DmrlkW+3bKFTbd4tDujyG4JWY1zArwv67egEZlaImKc7MeWcY+wGWIgYMYHkLpv759N19xMCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAqJOdVQq9K5qkc4+F5HnqaYCOi22bEQBbfkwd7Xg6bId6noO5BOtvI/N8ndG9TqtavME689M4mqIZamOOUiDUawjcuVmx6SgiYa+e5S3Q5iwGJuYYALeZUEhBYLNSZvM7twrx7VUd/i7hkovFrQzCJrzk3rcjMK9fGfXmRQUiJa937OBYtji6Z/7ppMW9/VBI+LjBWj8hKcuYVYO10PqBubColL3kk2OvErUAHgU6xGEwCVFy62rTyAQ0wwVXE+P7XIeKb8RXkE1PECuAbXxxhvScBohZ+LYlWz4UtRAF0Uz3WGCb5HEju4rv06jgsSZWBuPeKt5yExMYzzQ0tvXqsw==
cf38d02c-8487-485e-a77a-8dc0d44b4d67	5014ab17-979a-4f93-b308-3db48c1187c6	privateKey	MIIEpAIBAAKCAQEA2FyCgRbF5joF1rMNAu+z4H4EKzGAu0h9OJx2NPUGhWx/bjGGPLYu+Rdpi5P+T5Fk3z7rAgmGH2yOeXieBkLX6jO76lks0uLCkMdB+itEe8k309lzmj6RPsqxQYVkTrWUA42taUg4gQT/uPbR6kjK7/iJgpf8Qh91O+BLdSovmM7AZRnVMY+UwvxbdUArRpnbst/VxJ61Jtx7OBdrlF2dKFmXEZFPxV3lxYBwJP3tDkgpXSZwMNwu22LMiymvPuNV9LfE+O5CEdDdt03gMgKMBiiVQcgog2IvTPT8gg662OmacFmEtTg4ZMOnH4147M8op8jUDJBu822SWRKeEXtGXwIDAQABAoIBADzdKUkvItS1Fddj3xEoZS2NxZZxAomsxq0aNpaHJyJ5dw+ElwKVLXmdAG/nXe78M6gphuq3yycj3qCFMc8JFrwneYFfPKDGcX1Q0FqTuVwpKq9JyJ9nYmyLkHmiEKmjotOtE08+pcaFpXpe1IZXm98Nx4EZSDlBqDUDz7ZR+7m8SxTo7clZcI8X+1tKDBalrSWccW5AdEz614RNYKd36nEREIMoGCAHUUa1OBA6RI7ZGCOausHgTI/hUgm/y3cE7KOY1SpJrnPxEXgpQjo53Ksm0BwiAS83HcmMnE6+pwQcekB5I7jMn+ybK7O2HF7LYYphsfJqcK8hu3lodEHsUgECgYEA9UFXagd93tdq++zzdiCL5HR0CZS0aMdCQtM4by7u9xw5UtsGlYjhSjSOCx5A4aKla2uFxfTggcqwo3xmIDU24lnryIKehDpYFp8WhXEGrUpGjIaoTzDStOWj5In4fIyP4BoNq0v7pHuvXLAUuPucAz2ndN6Wz32RbyT5WYA3AB8CgYEA4dcb+QvdQEWKc6Y31PcmvbXtuidV2cRtAEBd1YEHiIpFrkxOeQbIryUaLku/JPR40hiwvWNungKsPwKhRYPAus3gXC0ClNP6rKOJeF2dhFm+qcQmDS7luSiTKiQJRvruRiB7q2TmQMzgL8pCl/5sL0be7+ymitT47avoMyY58cECgYEA7vMWo+tgq3jed01Jd1IGejMryxnjHCLnYAxC87CaipApGZzkMVUHizDhI9v6AtxgpuQ/lbsb8dj1eJN/POob6zUJEHaS0um1YXTmkGSqyLORQOEBowZChJUotUXnoBGjLAi2QKrrJjqLhJbZ2dDrFA1B1g/4h3gj9lHjz1uoOqkCgYEAlGiihj+oroLEYAlb6URdHg/+3/TXctqk8qRZxWMcSzrqXYbhjqDJomcUVFYMj0FkYFQ/WMWNvKJvBJ06046oSVnfVVNyvdCri2WQghuq1n2PUMqIYuNtrQaf5vJ1ckKV8FmKS3Br6yt3K5CTwIQ+HbdJ64qtStB3oN/2IB6/t0ECgYBWQmw4qlRhI5KzAH7/lFSx40O3P603glKzIzxroeVNWWT/MssFVlyAxXOEs2TLOwoBPnBWJdux0vsHOJT6H7B7HlG4MeVoJKeYNqznYHq/1355PEnet8pl1acxpgamdub+A6BE7OL6Xhdxrp1+5pu7wyzb6fSOZunZ2pdvr8pbIw==
9d452252-d24f-48f6-881d-3277aae00aa1	5014ab17-979a-4f93-b308-3db48c1187c6	keyUse	SIG
22799fa1-bc2b-436b-a462-52cd1788e9e3	5014ab17-979a-4f93-b308-3db48c1187c6	certificate	MIICnTCCAYUCBgGOHgs3ADANBgkqhkiG9w0BAQsFADASMRAwDgYDVQQDDAdleGFtcGxlMB4XDTI0MDMwODEyMjg1NVoXDTM0MDMwODEyMzAzNVowEjEQMA4GA1UEAwwHZXhhbXBsZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANhcgoEWxeY6BdazDQLvs+B+BCsxgLtIfTicdjT1BoVsf24xhjy2LvkXaYuT/k+RZN8+6wIJhh9sjnl4ngZC1+ozu+pZLNLiwpDHQforRHvJN9PZc5o+kT7KsUGFZE61lAONrWlIOIEE/7j20epIyu/4iYKX/EIfdTvgS3UqL5jOwGUZ1TGPlML8W3VAK0aZ27Lf1cSetSbcezgXa5RdnShZlxGRT8Vd5cWAcCT97Q5IKV0mcDDcLttizIsprz7jVfS3xPjuQhHQ3bdN4DICjAYolUHIKINiL0z0/IIOutjpmnBZhLU4OGTDpx+NeOzPKKfI1AyQbvNtklkSnhF7Rl8CAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAPo96oFyL/AF8+qtvvZM5wH3fmpC2hshQMQTMgPEL5ZuOcoZxQGaPFdJKm5whbR8dhKabGKDnI0+4S1q29vBnW5XY8oNlwUrJVs+ah/Pdk4VPoVlRvPDyTnzNy+TGUfheK8dq3i215/fsrHuaMEsKjl29cO77D55rJG8NMfYyzYCugwZxli3H8UN5c6UkFjRzGD6xxg/klLc1EtLi6c5OfAb9o/HISr9qOLjtsNB+X85co0s8IKbJJ2bsjc3yObbWiGqTUSkCGWiC9B12zC2G70TC6t4go39jE6SSn9QIYJmne5VvKBJiCXEBgScN6h8QD3sf+q0EtINRA3uD9X1Ajw==
e5d010a5-5753-4004-9190-0ce3c829325a	5014ab17-979a-4f93-b308-3db48c1187c6	priority	100
58fcea22-2080-4abd-aa28-b10abece9bf1	9395165d-75e5-4be3-86a3-60f7672d3e5e	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
cdc3f08f-2f7e-4206-a5c5-897e7da9f175	9395165d-75e5-4be3-86a3-60f7672d3e5e	allowed-protocol-mapper-types	saml-role-list-mapper
7077508f-3a3a-4087-a99e-44b5a506d439	9395165d-75e5-4be3-86a3-60f7672d3e5e	allowed-protocol-mapper-types	saml-user-property-mapper
3cf3dc0d-80d6-4218-b459-f9640fd6e0af	9395165d-75e5-4be3-86a3-60f7672d3e5e	allowed-protocol-mapper-types	oidc-full-name-mapper
a6533e25-8ff5-47fc-accb-298fb62c002a	9395165d-75e5-4be3-86a3-60f7672d3e5e	allowed-protocol-mapper-types	saml-user-attribute-mapper
d1bbdac6-0155-41e3-bd60-31579b5b948f	9395165d-75e5-4be3-86a3-60f7672d3e5e	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
d4312bf9-c67f-4e27-b53f-4037a35da7eb	9395165d-75e5-4be3-86a3-60f7672d3e5e	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
3ecf7f16-1a70-4456-9969-51613945ca5d	9395165d-75e5-4be3-86a3-60f7672d3e5e	allowed-protocol-mapper-types	oidc-address-mapper
c5ebc225-215b-468b-88d0-1399228fd4ba	37df9d49-c0fb-4057-80dc-80f868bd4b60	allow-default-scopes	true
9341f726-c767-4ff3-9b2f-7cd4ab6c070b	f793f2ec-2fec-455f-aa82-725b41f8eabd	allow-default-scopes	true
83040c4a-fcb3-450d-9a1f-3970e3fd107d	cc5d8818-2e25-4f3a-b29d-34cd84a3e850	allowed-protocol-mapper-types	saml-user-attribute-mapper
b3509ac7-4d94-4f15-87cd-5bfd10154155	cc5d8818-2e25-4f3a-b29d-34cd84a3e850	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
950c4120-4779-4332-b1d1-debf9ef9cf2d	cc5d8818-2e25-4f3a-b29d-34cd84a3e850	allowed-protocol-mapper-types	oidc-full-name-mapper
7234ac3b-d577-48dc-9d2c-6ff6be868deb	cc5d8818-2e25-4f3a-b29d-34cd84a3e850	allowed-protocol-mapper-types	saml-role-list-mapper
21d63f88-089e-4223-a89c-d11d85c886f6	cc5d8818-2e25-4f3a-b29d-34cd84a3e850	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
3f15bd99-d2f2-422b-8372-eb705726757d	cc5d8818-2e25-4f3a-b29d-34cd84a3e850	allowed-protocol-mapper-types	oidc-address-mapper
ca138f11-0506-4334-a0e2-7ad1086f7d5a	cc5d8818-2e25-4f3a-b29d-34cd84a3e850	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
92409772-e112-438e-ac9c-23daf9fcb72c	cc5d8818-2e25-4f3a-b29d-34cd84a3e850	allowed-protocol-mapper-types	saml-user-property-mapper
e2ff2ef4-af75-47da-9451-f7f58195c961	fc2edc58-87b7-4aff-9825-bac6f0d58578	host-sending-registration-request-must-match	true
6e4e5126-0f36-4328-b0e0-3ba39ad27453	fc2edc58-87b7-4aff-9825-bac6f0d58578	client-uris-must-match	true
7bf752f9-520d-4fbf-8407-e45117117a53	f83f6690-f29a-4c82-932d-07a69922b533	max-clients	200
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.composite_role (composite, child_role) FROM stdin;
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	bd034143-cac5-410a-a57e-7b5464e8fbdd
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	95253e7e-d613-4fe2-a490-5b5c6ec342f2
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	c2adb199-fa49-434a-a456-864667290972
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	ec88028e-bfb8-4496-8887-5e1da4d964ec
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	1dff0630-30c7-4ed2-bfca-a3dea971f95c
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	a97aa5c6-adcf-4f2b-ab9a-7ddd44e9207c
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	9de559e5-9c39-47fd-a9ca-ffe5dfc033b0
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	ffac56fc-b2fa-4897-ba8b-1aa1b126ca9d
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	0faf3f15-0792-416d-85c7-9733b4c856c6
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	3c0c9197-d8d3-446d-b4ad-cc15134c1f02
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	a0290f07-7922-4364-91f9-ace1abb0b075
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	0c030ac4-2bcf-4f0b-8455-0030f81dde38
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	a8161cb0-5d1a-413d-90cf-8e6ddb0f7e4a
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	10b9c59b-a1e1-489e-9d11-a28e73e83b30
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	8f85af81-f964-4bd9-931a-55474c0aa0de
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	c9aad030-460e-4d0e-84f8-37ab952b127e
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	b14f70cb-d633-4600-8ac4-57cfb7843332
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	04e80505-68a1-498b-b3c9-1dc3d802ad43
1dff0630-30c7-4ed2-bfca-a3dea971f95c	c9aad030-460e-4d0e-84f8-37ab952b127e
e8871570-ca3d-436d-813a-12ee4acd8c21	70527b68-e3ae-42f7-ad6b-63f97896c391
ec88028e-bfb8-4496-8887-5e1da4d964ec	8f85af81-f964-4bd9-931a-55474c0aa0de
ec88028e-bfb8-4496-8887-5e1da4d964ec	04e80505-68a1-498b-b3c9-1dc3d802ad43
e8871570-ca3d-436d-813a-12ee4acd8c21	16f404a0-ef99-4409-b4bb-b460d972dcca
16f404a0-ef99-4409-b4bb-b460d972dcca	06599950-2290-4fe9-b0c7-99f1a86cc12b
38bd1d58-2b02-4fb5-9702-dfecc7750cf9	60ed1d1f-3ec7-41dd-a944-ee81f0fed109
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	c7fd5ba7-34e1-43b8-b805-f6ddea5c6653
e8871570-ca3d-436d-813a-12ee4acd8c21	4f6dcbf3-e910-4786-9801-de3eaa4a6070
e8871570-ca3d-436d-813a-12ee4acd8c21	47f2d364-33a2-4b6e-8c65-90b66be3ba6f
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	857a7058-8cf7-42e0-9c06-024b898eea5d
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	fb87b87a-e9fe-4d05-b7c4-317e13464e0c
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	e015c760-61a9-45af-ba40-927a31bee687
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	2c4d9735-4529-47c6-97cd-618c3e9e8112
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	1c3be4f3-59c9-4970-acef-04830b749197
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	07078bc8-63d4-4512-b191-3f91586827de
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	64cb8900-c38c-4e81-a6fb-1f9e670cdc95
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	a42059e1-930c-42e7-bd73-ccc1a8b61207
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	2d576204-2ca1-4095-872f-ca7e744c0822
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	8b229319-e238-4837-9272-6e90d10c6016
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	69a75e20-6900-49e4-b6ce-408a869e99cb
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	6c6bded7-9c00-4870-b66b-8406531922ad
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	44266fa4-f67d-4406-a6a9-09e528b8f18a
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	5301f743-3edf-42f9-bd7f-50bc8378f19c
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	780596a5-f019-4ca7-ae5f-466f111e86ea
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	9ee436aa-aed3-4de0-96ea-ddb41f76db41
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	05585f82-4cba-44ff-98bb-2e98e573ed09
2c4d9735-4529-47c6-97cd-618c3e9e8112	780596a5-f019-4ca7-ae5f-466f111e86ea
e015c760-61a9-45af-ba40-927a31bee687	05585f82-4cba-44ff-98bb-2e98e573ed09
e015c760-61a9-45af-ba40-927a31bee687	5301f743-3edf-42f9-bd7f-50bc8378f19c
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	c583a05b-ff62-415c-9cc1-552d72b8fca5
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	2a667b6d-f0fa-45a9-b7cc-5bdcdc88f5bf
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	d8ca7186-57a7-4777-b10e-1ad1b4966d0d
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	c4d04fa5-8849-4ef3-8b40-78e4da59ecc1
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	9eda0300-7f09-4e12-a6ef-1c21cfef6334
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	5c0cf5a0-f050-4a36-a34f-8ed870b7527c
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	d51fc16f-c111-4611-b8a1-c38f92f28e0a
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	c135ccb0-e9fe-4409-95ea-372d7cef7fc1
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	d5145725-1d3d-4251-a137-d587f690218e
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	44a1b9ab-d8ed-478b-8695-af28ee426d56
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	3d8640d2-20fd-400f-b0e3-adf60cf8d055
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	a1bbf1b3-5d4f-408c-b605-66e246bd8dbe
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	aa2e0f01-8360-45a8-a5c7-c259466f8d86
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	12f67ea1-6569-4704-945b-12234cf4318f
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	48d4eff0-15bd-49f3-b9be-fc2143c25e1d
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	e3cfe99c-e2e0-493c-be65-f03f6f8b499b
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	99c12a94-2670-47a8-a203-6111dbd15c70
c4d04fa5-8849-4ef3-8b40-78e4da59ecc1	48d4eff0-15bd-49f3-b9be-fc2143c25e1d
cf14231c-140c-4652-a5d6-27522144626a	b8584074-2d43-4063-8b1b-eabd160afc1a
d8ca7186-57a7-4777-b10e-1ad1b4966d0d	99c12a94-2670-47a8-a203-6111dbd15c70
d8ca7186-57a7-4777-b10e-1ad1b4966d0d	12f67ea1-6569-4704-945b-12234cf4318f
cf14231c-140c-4652-a5d6-27522144626a	b8d13099-955f-4945-a9a5-d67e60edc5c5
b8d13099-955f-4945-a9a5-d67e60edc5c5	7c78d3ee-5655-45c0-88a8-479b047aa976
87259851-a530-4845-8a96-b2d5427aa9e6	37035570-db88-4f4a-9c43-8496abe34bfe
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	050ca202-d92d-4258-b30b-3c553196a854
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	3903a887-4c6f-4391-a5bc-91477a9e2938
cf14231c-140c-4652-a5d6-27522144626a	5c39235a-6e41-4b79-8ea9-5e8a9c4c2427
cf14231c-140c-4652-a5d6-27522144626a	4df3683d-1f34-42c8-ae4f-ba0618355ba7
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
cf8e166b-3a15-4343-aa71-ee4ceff42176	\N	password	7fc35427-0949-489c-a10c-de4238fba2d6	1709901012491	\N	{"value":"I9fZ5UR8v//5BrC2Zs77Y1ydl0snFs3YXrzli6UZS4g=","salt":"UXgEAMQAUfcilhQgM2lyWQ==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
73ef9beb-4e50-40e8-ae8b-829378fa2f49	\N	password	f07ea084-8941-4f5c-8195-a02c6386cdc7	1709901354044	PW: user1	{"value":"WNXnyyJQsdJDu7vmGIFWWTXWtprM+pdcmi+kRKmCSa8=","salt":"K10Vlf/DqeDUPFevaag0uQ==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2024-03-08 12:30:10.069622	1	EXECUTED	9:6f1016664e21e16d26517a4418f5e3df	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.23.2	\N	\N	9901009688
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2024-03-08 12:30:10.096154	2	MARK_RAN	9:828775b1596a07d1200ba1d49e5e3941	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.23.2	\N	\N	9901009688
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2024-03-08 12:30:10.121876	3	EXECUTED	9:5f090e44a7d595883c1fb61f4b41fd38	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.23.2	\N	\N	9901009688
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2024-03-08 12:30:10.123897	4	EXECUTED	9:c07e577387a3d2c04d1adc9aaad8730e	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.23.2	\N	\N	9901009688
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2024-03-08 12:30:10.179702	5	EXECUTED	9:b68ce996c655922dbcd2fe6b6ae72686	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.23.2	\N	\N	9901009688
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2024-03-08 12:30:10.189415	6	MARK_RAN	9:543b5c9989f024fe35c6f6c5a97de88e	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.23.2	\N	\N	9901009688
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2024-03-08 12:30:10.241417	7	EXECUTED	9:765afebbe21cf5bbca048e632df38336	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.23.2	\N	\N	9901009688
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2024-03-08 12:30:10.253962	8	MARK_RAN	9:db4a145ba11a6fdaefb397f6dbf829a1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.23.2	\N	\N	9901009688
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2024-03-08 12:30:10.258527	9	EXECUTED	9:9d05c7be10cdb873f8bcb41bc3a8ab23	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.23.2	\N	\N	9901009688
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2024-03-08 12:30:10.337311	10	EXECUTED	9:18593702353128d53111f9b1ff0b82b8	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.23.2	\N	\N	9901009688
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2024-03-08 12:30:10.38371	11	EXECUTED	9:6122efe5f090e41a85c0f1c9e52cbb62	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.23.2	\N	\N	9901009688
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2024-03-08 12:30:10.389654	12	MARK_RAN	9:e1ff28bf7568451453f844c5d54bb0b5	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.23.2	\N	\N	9901009688
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2024-03-08 12:30:10.436913	13	EXECUTED	9:7af32cd8957fbc069f796b61217483fd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.23.2	\N	\N	9901009688
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-03-08 12:30:10.45606	14	EXECUTED	9:6005e15e84714cd83226bf7879f54190	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.23.2	\N	\N	9901009688
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-03-08 12:30:10.457153	15	MARK_RAN	9:bf656f5a2b055d07f314431cae76f06c	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.23.2	\N	\N	9901009688
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-03-08 12:30:10.459063	16	MARK_RAN	9:f8dadc9284440469dcf71e25ca6ab99b	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.23.2	\N	\N	9901009688
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-03-08 12:30:10.460671	17	EXECUTED	9:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.23.2	\N	\N	9901009688
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2024-03-08 12:30:10.496432	18	EXECUTED	9:3368ff0be4c2855ee2dd9ca813b38d8e	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.23.2	\N	\N	9901009688
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2024-03-08 12:30:10.529984	19	EXECUTED	9:8ac2fb5dd030b24c0570a763ed75ed20	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.23.2	\N	\N	9901009688
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2024-03-08 12:30:10.532216	20	EXECUTED	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.23.2	\N	\N	9901009688
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2024-03-08 12:30:10.53775	21	MARK_RAN	9:831e82914316dc8a57dc09d755f23c51	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.23.2	\N	\N	9901009688
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2024-03-08 12:30:10.539872	22	MARK_RAN	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.23.2	\N	\N	9901009688
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2024-03-08 12:30:10.550624	23	EXECUTED	9:bc3d0f9e823a69dc21e23e94c7a94bb1	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.23.2	\N	\N	9901009688
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2024-03-08 12:30:10.552837	24	EXECUTED	9:c9999da42f543575ab790e76439a2679	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.23.2	\N	\N	9901009688
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2024-03-08 12:30:10.55353	25	MARK_RAN	9:0d6c65c6f58732d81569e77b10ba301d	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.23.2	\N	\N	9901009688
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2024-03-08 12:30:10.56809	26	EXECUTED	9:fc576660fc016ae53d2d4778d84d86d0	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.23.2	\N	\N	9901009688
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2024-03-08 12:30:10.604575	27	EXECUTED	9:43ed6b0da89ff77206289e87eaa9c024	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.23.2	\N	\N	9901009688
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2024-03-08 12:30:10.60681	28	EXECUTED	9:44bae577f551b3738740281eceb4ea70	update tableName=RESOURCE_SERVER_POLICY		\N	4.23.2	\N	\N	9901009688
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2024-03-08 12:30:10.633378	29	EXECUTED	9:bd88e1f833df0420b01e114533aee5e8	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.23.2	\N	\N	9901009688
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2024-03-08 12:30:10.639962	30	EXECUTED	9:a7022af5267f019d020edfe316ef4371	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.23.2	\N	\N	9901009688
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2024-03-08 12:30:10.647561	31	EXECUTED	9:fc155c394040654d6a79227e56f5e25a	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.23.2	\N	\N	9901009688
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2024-03-08 12:30:10.650412	32	EXECUTED	9:eac4ffb2a14795e5dc7b426063e54d88	customChange		\N	4.23.2	\N	\N	9901009688
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-03-08 12:30:10.653074	33	EXECUTED	9:54937c05672568c4c64fc9524c1e9462	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.23.2	\N	\N	9901009688
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-03-08 12:30:10.654923	34	MARK_RAN	9:3a32bace77c84d7678d035a7f5a8084e	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.23.2	\N	\N	9901009688
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-03-08 12:30:10.671625	35	EXECUTED	9:33d72168746f81f98ae3a1e8e0ca3554	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.23.2	\N	\N	9901009688
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2024-03-08 12:30:10.68172	36	EXECUTED	9:61b6d3d7a4c0e0024b0c839da283da0c	addColumn tableName=REALM		\N	4.23.2	\N	\N	9901009688
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-03-08 12:30:10.684419	37	EXECUTED	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.23.2	\N	\N	9901009688
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2024-03-08 12:30:10.685945	38	EXECUTED	9:a2b870802540cb3faa72098db5388af3	addColumn tableName=FED_USER_CONSENT		\N	4.23.2	\N	\N	9901009688
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2024-03-08 12:30:10.690039	39	EXECUTED	9:132a67499ba24bcc54fb5cbdcfe7e4c0	addColumn tableName=IDENTITY_PROVIDER		\N	4.23.2	\N	\N	9901009688
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2024-03-08 12:30:10.690779	40	MARK_RAN	9:938f894c032f5430f2b0fafb1a243462	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.23.2	\N	\N	9901009688
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2024-03-08 12:30:10.691954	41	MARK_RAN	9:845c332ff1874dc5d35974b0babf3006	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.23.2	\N	\N	9901009688
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2024-03-08 12:30:10.696832	42	EXECUTED	9:fc86359c079781adc577c5a217e4d04c	customChange		\N	4.23.2	\N	\N	9901009688
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2024-03-08 12:30:10.756555	43	EXECUTED	9:59a64800e3c0d09b825f8a3b444fa8f4	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.23.2	\N	\N	9901009688
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2024-03-08 12:30:10.763972	44	EXECUTED	9:d48d6da5c6ccf667807f633fe489ce88	addColumn tableName=USER_ENTITY		\N	4.23.2	\N	\N	9901009688
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-03-08 12:30:10.765673	45	EXECUTED	9:dde36f7973e80d71fceee683bc5d2951	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.23.2	\N	\N	9901009688
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-03-08 12:30:10.76761	46	EXECUTED	9:b855e9b0a406b34fa323235a0cf4f640	customChange		\N	4.23.2	\N	\N	9901009688
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-03-08 12:30:10.768276	47	MARK_RAN	9:51abbacd7b416c50c4421a8cabf7927e	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.23.2	\N	\N	9901009688
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-03-08 12:30:10.78487	48	EXECUTED	9:bdc99e567b3398bac83263d375aad143	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.23.2	\N	\N	9901009688
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-03-08 12:30:10.793631	49	EXECUTED	9:d198654156881c46bfba39abd7769e69	addColumn tableName=REALM		\N	4.23.2	\N	\N	9901009688
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2024-03-08 12:30:10.815229	50	EXECUTED	9:cfdd8736332ccdd72c5256ccb42335db	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.23.2	\N	\N	9901009688
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2024-03-08 12:30:10.828544	51	EXECUTED	9:7c84de3d9bd84d7f077607c1a4dcb714	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.23.2	\N	\N	9901009688
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2024-03-08 12:30:10.829918	52	EXECUTED	9:5a6bb36cbefb6a9d6928452c0852af2d	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.23.2	\N	\N	9901009688
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2024-03-08 12:30:10.831171	53	EXECUTED	9:8f23e334dbc59f82e0a328373ca6ced0	update tableName=REALM		\N	4.23.2	\N	\N	9901009688
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2024-03-08 12:30:10.832227	54	EXECUTED	9:9156214268f09d970cdf0e1564d866af	update tableName=CLIENT		\N	4.23.2	\N	\N	9901009688
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-03-08 12:30:10.834687	55	EXECUTED	9:db806613b1ed154826c02610b7dbdf74	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.23.2	\N	\N	9901009688
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-03-08 12:30:10.836403	56	EXECUTED	9:229a041fb72d5beac76bb94a5fa709de	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.23.2	\N	\N	9901009688
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-03-08 12:30:10.85452	57	EXECUTED	9:079899dade9c1e683f26b2aa9ca6ff04	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.23.2	\N	\N	9901009688
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-03-08 12:30:10.89547	58	EXECUTED	9:139b79bcbbfe903bb1c2d2a4dbf001d9	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.23.2	\N	\N	9901009688
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2024-03-08 12:30:10.915721	59	EXECUTED	9:b55738ad889860c625ba2bf483495a04	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.23.2	\N	\N	9901009688
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2024-03-08 12:30:10.91943	60	EXECUTED	9:e0057eac39aa8fc8e09ac6cfa4ae15fe	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.23.2	\N	\N	9901009688
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2024-03-08 12:30:10.924542	61	EXECUTED	9:42a33806f3a0443fe0e7feeec821326c	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.23.2	\N	\N	9901009688
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2024-03-08 12:30:10.927016	62	EXECUTED	9:9968206fca46eecc1f51db9c024bfe56	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.23.2	\N	\N	9901009688
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2024-03-08 12:30:10.928288	63	EXECUTED	9:92143a6daea0a3f3b8f598c97ce55c3d	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.23.2	\N	\N	9901009688
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2024-03-08 12:30:10.929547	64	EXECUTED	9:82bab26a27195d889fb0429003b18f40	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.23.2	\N	\N	9901009688
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2024-03-08 12:30:10.930834	65	EXECUTED	9:e590c88ddc0b38b0ae4249bbfcb5abc3	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.23.2	\N	\N	9901009688
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2024-03-08 12:30:10.937076	66	EXECUTED	9:5c1f475536118dbdc38d5d7977950cc0	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.23.2	\N	\N	9901009688
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2024-03-08 12:30:10.939251	67	EXECUTED	9:e7c9f5f9c4d67ccbbcc215440c718a17	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.23.2	\N	\N	9901009688
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2024-03-08 12:30:10.95012	68	EXECUTED	9:88e0bfdda924690d6f4e430c53447dd5	addColumn tableName=REALM		\N	4.23.2	\N	\N	9901009688
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2024-03-08 12:30:10.957744	69	EXECUTED	9:f53177f137e1c46b6a88c59ec1cb5218	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.23.2	\N	\N	9901009688
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2024-03-08 12:30:10.960368	70	EXECUTED	9:a74d33da4dc42a37ec27121580d1459f	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.23.2	\N	\N	9901009688
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2024-03-08 12:30:10.963308	71	EXECUTED	9:fd4ade7b90c3b67fae0bfcfcb42dfb5f	addColumn tableName=RESOURCE_SERVER		\N	4.23.2	\N	\N	9901009688
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-03-08 12:30:10.965538	72	EXECUTED	9:aa072ad090bbba210d8f18781b8cebf4	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.23.2	\N	\N	9901009688
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-03-08 12:30:10.968428	73	EXECUTED	9:1ae6be29bab7c2aa376f6983b932be37	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.23.2	\N	\N	9901009688
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-03-08 12:30:10.969618	74	MARK_RAN	9:14706f286953fc9a25286dbd8fb30d97	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.23.2	\N	\N	9901009688
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-03-08 12:30:10.977776	75	EXECUTED	9:2b9cc12779be32c5b40e2e67711a218b	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.23.2	\N	\N	9901009688
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-03-08 12:30:10.982165	76	EXECUTED	9:91fa186ce7a5af127a2d7a91ee083cc5	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.23.2	\N	\N	9901009688
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-03-08 12:30:10.989	77	EXECUTED	9:6335e5c94e83a2639ccd68dd24e2e5ad	addColumn tableName=CLIENT		\N	4.23.2	\N	\N	9901009688
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-03-08 12:30:10.989925	78	MARK_RAN	9:6bdb5658951e028bfe16fa0a8228b530	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.23.2	\N	\N	9901009688
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-03-08 12:30:10.997369	79	EXECUTED	9:d5bc15a64117ccad481ce8792d4c608f	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.23.2	\N	\N	9901009688
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-03-08 12:30:10.999293	80	MARK_RAN	9:077cba51999515f4d3e7ad5619ab592c	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.23.2	\N	\N	9901009688
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-03-08 12:30:11.002269	81	EXECUTED	9:be969f08a163bf47c6b9e9ead8ac2afb	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.23.2	\N	\N	9901009688
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-03-08 12:30:11.003378	82	MARK_RAN	9:6d3bb4408ba5a72f39bd8a0b301ec6e3	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.23.2	\N	\N	9901009688
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-03-08 12:30:11.005094	83	EXECUTED	9:966bda61e46bebf3cc39518fbed52fa7	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.23.2	\N	\N	9901009688
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-03-08 12:30:11.005776	84	MARK_RAN	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.23.2	\N	\N	9901009688
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-03-08 12:30:11.008247	85	EXECUTED	9:7d93d602352a30c0c317e6a609b56599	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.23.2	\N	\N	9901009688
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2024-03-08 12:30:11.010089	86	EXECUTED	9:71c5969e6cdd8d7b6f47cebc86d37627	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.23.2	\N	\N	9901009688
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2024-03-08 12:30:11.012535	87	EXECUTED	9:a9ba7d47f065f041b7da856a81762021	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.23.2	\N	\N	9901009688
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2024-03-08 12:30:11.015753	88	EXECUTED	9:fffabce2bc01e1a8f5110d5278500065	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.23.2	\N	\N	9901009688
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-03-08 12:30:11.01817	89	EXECUTED	9:fa8a5b5445e3857f4b010bafb5009957	addColumn tableName=REALM; customChange		\N	4.23.2	\N	\N	9901009688
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-03-08 12:30:11.021406	90	EXECUTED	9:67ac3241df9a8582d591c5ed87125f39	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.23.2	\N	\N	9901009688
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-03-08 12:30:11.023828	91	EXECUTED	9:ad1194d66c937e3ffc82386c050ba089	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.23.2	\N	\N	9901009688
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-03-08 12:30:11.026454	92	EXECUTED	9:d9be619d94af5a2f5d07b9f003543b91	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.23.2	\N	\N	9901009688
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-03-08 12:30:11.027084	93	MARK_RAN	9:544d201116a0fcc5a5da0925fbbc3bde	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.23.2	\N	\N	9901009688
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-03-08 12:30:11.030147	94	EXECUTED	9:43c0c1055b6761b4b3e89de76d612ccf	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.23.2	\N	\N	9901009688
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-03-08 12:30:11.031342	95	MARK_RAN	9:8bd711fd0330f4fe980494ca43ab1139	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.23.2	\N	\N	9901009688
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-03-08 12:30:11.034171	96	EXECUTED	9:e07d2bc0970c348bb06fb63b1f82ddbf	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.23.2	\N	\N	9901009688
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-03-08 12:30:11.03797	97	EXECUTED	9:24fb8611e97f29989bea412aa38d12b7	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.23.2	\N	\N	9901009688
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-03-08 12:30:11.038642	98	MARK_RAN	9:259f89014ce2506ee84740cbf7163aa7	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.23.2	\N	\N	9901009688
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-03-08 12:30:11.042184	99	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.23.2	\N	\N	9901009688
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-03-08 12:30:11.045115	100	EXECUTED	9:60ca84a0f8c94ec8c3504a5a3bc88ee8	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.23.2	\N	\N	9901009688
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-03-08 12:30:11.045897	101	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.23.2	\N	\N	9901009688
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-03-08 12:30:11.048467	102	EXECUTED	9:0b305d8d1277f3a89a0a53a659ad274c	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.23.2	\N	\N	9901009688
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-03-08 12:30:11.050898	103	EXECUTED	9:2c374ad2cdfe20e2905a84c8fac48460	customChange		\N	4.23.2	\N	\N	9901009688
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2024-03-08 12:30:11.053725	104	EXECUTED	9:47a760639ac597360a8219f5b768b4de	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.23.2	\N	\N	9901009688
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2024-03-08 12:30:11.055876	105	EXECUTED	9:a6272f0576727dd8cad2522335f5d99e	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.23.2	\N	\N	9901009688
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2024-03-08 12:30:11.058025	106	EXECUTED	9:015479dbd691d9cc8669282f4828c41d	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.23.2	\N	\N	9901009688
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2024-03-08 12:30:11.060026	107	EXECUTED	9:9518e495fdd22f78ad6425cc30630221	customChange		\N	4.23.2	\N	\N	9901009688
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2024-03-08 12:30:11.062558	108	EXECUTED	9:e5f243877199fd96bcc842f27a1656ac	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.23.2	\N	\N	9901009688
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2024-03-08 12:30:11.063372	109	MARK_RAN	9:1a6fcaa85e20bdeae0a9ce49b41946a5	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.23.2	\N	\N	9901009688
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2024-03-08 12:30:11.067297	110	EXECUTED	9:3f332e13e90739ed0c35b0b25b7822ca	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.23.2	\N	\N	9901009688
21.0.2-17277	keycloak	META-INF/jpa-changelog-21.0.2.xml	2024-03-08 12:30:11.069506	111	EXECUTED	9:7ee1f7a3fb8f5588f171fb9a6ab623c0	customChange		\N	4.23.2	\N	\N	9901009688
21.1.0-19404	keycloak	META-INF/jpa-changelog-21.1.0.xml	2024-03-08 12:30:11.082529	112	EXECUTED	9:3d7e830b52f33676b9d64f7f2b2ea634	modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER		\N	4.23.2	\N	\N	9901009688
21.1.0-19404-2	keycloak	META-INF/jpa-changelog-21.1.0.xml	2024-03-08 12:30:11.084089	113	MARK_RAN	9:627d032e3ef2c06c0e1f73d2ae25c26c	addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...		\N	4.23.2	\N	\N	9901009688
22.0.0-17484-updated	keycloak	META-INF/jpa-changelog-22.0.0.xml	2024-03-08 12:30:11.086411	114	EXECUTED	9:90af0bfd30cafc17b9f4d6eccd92b8b3	customChange		\N	4.23.2	\N	\N	9901009688
22.0.5-24031	keycloak	META-INF/jpa-changelog-22.0.0.xml	2024-03-08 12:30:11.087127	115	MARK_RAN	9:a60d2d7b315ec2d3eba9e2f145f9df28	customChange		\N	4.23.2	\N	\N	9901009688
23.0.0-12062	keycloak	META-INF/jpa-changelog-23.0.0.xml	2024-03-08 12:30:11.089707	116	EXECUTED	9:2168fbe728fec46ae9baf15bf80927b8	addColumn tableName=COMPONENT_CONFIG; update tableName=COMPONENT_CONFIG; dropColumn columnName=VALUE, tableName=COMPONENT_CONFIG; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=COMPONENT_CONFIG		\N	4.23.2	\N	\N	9901009688
23.0.0-17258	keycloak	META-INF/jpa-changelog-23.0.0.xml	2024-03-08 12:30:11.091223	117	EXECUTED	9:36506d679a83bbfda85a27ea1864dca8	addColumn tableName=EVENT_ENTITY		\N	4.23.2	\N	\N	9901009688
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
1001	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
438d433b-f366-40dc-9637-569f7d936a93	64332c2d-d08c-4b27-a2ae-fe83400c473f	f
438d433b-f366-40dc-9637-569f7d936a93	806e1e50-749a-4afe-af19-1885b9a6527e	t
438d433b-f366-40dc-9637-569f7d936a93	5c3a75d8-4031-41ca-b7c2-f57016ac6e88	t
438d433b-f366-40dc-9637-569f7d936a93	8628575a-2ac6-4af6-9921-b4744adeafdf	t
438d433b-f366-40dc-9637-569f7d936a93	9bb8c391-26a7-4069-b9a7-2c6265738c82	f
438d433b-f366-40dc-9637-569f7d936a93	15e0944d-c431-433e-afc6-720344ab3fe2	f
438d433b-f366-40dc-9637-569f7d936a93	e2b5e15d-bcd9-473a-a91c-61a1dfa5450d	t
438d433b-f366-40dc-9637-569f7d936a93	39210741-116c-4842-9f99-a3393f95c4a8	t
438d433b-f366-40dc-9637-569f7d936a93	a6a8e1c1-a62b-48e9-8b38-2cb8fa272747	f
438d433b-f366-40dc-9637-569f7d936a93	37c3e3aa-47d8-4834-af51-6a46a287e727	t
a465077b-0c7f-4fcc-bf69-d3f0805cefe5	b2fa6c06-6237-47e9-b0fe-1486b60792bd	f
a465077b-0c7f-4fcc-bf69-d3f0805cefe5	ae8cd3ea-c159-4109-a4d5-9a1769991259	t
a465077b-0c7f-4fcc-bf69-d3f0805cefe5	fb340605-a470-4668-b6bb-491ffb2b1ab6	t
a465077b-0c7f-4fcc-bf69-d3f0805cefe5	ed9f1561-b7c5-4ef4-a123-59413fb97e9e	t
a465077b-0c7f-4fcc-bf69-d3f0805cefe5	d952f795-e55f-4f44-9b01-7afb4e0497c1	f
a465077b-0c7f-4fcc-bf69-d3f0805cefe5	ee481d9d-1f07-44af-bef5-69b4beb1c762	f
a465077b-0c7f-4fcc-bf69-d3f0805cefe5	24797bf1-e2a9-45af-b1aa-597dc4a8cbf0	t
a465077b-0c7f-4fcc-bf69-d3f0805cefe5	89cb8f94-6c38-4712-a712-d511e9c26fbc	t
a465077b-0c7f-4fcc-bf69-d3f0805cefe5	5a42ce5e-105b-433f-bd81-8646190ed523	f
a465077b-0c7f-4fcc-bf69-d3f0805cefe5	cebe2803-77df-4640-b7c1-4a32faa5dd94	t
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id, details_json_long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.keycloak_group (id, name, parent_group, realm_id) FROM stdin;
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
e8871570-ca3d-436d-813a-12ee4acd8c21	438d433b-f366-40dc-9637-569f7d936a93	f	${role_default-roles}	default-roles-master	438d433b-f366-40dc-9637-569f7d936a93	\N	\N
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	438d433b-f366-40dc-9637-569f7d936a93	f	${role_admin}	admin	438d433b-f366-40dc-9637-569f7d936a93	\N	\N
bd034143-cac5-410a-a57e-7b5464e8fbdd	438d433b-f366-40dc-9637-569f7d936a93	f	${role_create-realm}	create-realm	438d433b-f366-40dc-9637-569f7d936a93	\N	\N
95253e7e-d613-4fe2-a490-5b5c6ec342f2	e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	${role_create-client}	create-client	438d433b-f366-40dc-9637-569f7d936a93	e7133bf8-32fa-476a-bddf-d92d4bad00e5	\N
c2adb199-fa49-434a-a456-864667290972	e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	${role_view-realm}	view-realm	438d433b-f366-40dc-9637-569f7d936a93	e7133bf8-32fa-476a-bddf-d92d4bad00e5	\N
ec88028e-bfb8-4496-8887-5e1da4d964ec	e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	${role_view-users}	view-users	438d433b-f366-40dc-9637-569f7d936a93	e7133bf8-32fa-476a-bddf-d92d4bad00e5	\N
1dff0630-30c7-4ed2-bfca-a3dea971f95c	e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	${role_view-clients}	view-clients	438d433b-f366-40dc-9637-569f7d936a93	e7133bf8-32fa-476a-bddf-d92d4bad00e5	\N
a97aa5c6-adcf-4f2b-ab9a-7ddd44e9207c	e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	${role_view-events}	view-events	438d433b-f366-40dc-9637-569f7d936a93	e7133bf8-32fa-476a-bddf-d92d4bad00e5	\N
9de559e5-9c39-47fd-a9ca-ffe5dfc033b0	e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	${role_view-identity-providers}	view-identity-providers	438d433b-f366-40dc-9637-569f7d936a93	e7133bf8-32fa-476a-bddf-d92d4bad00e5	\N
ffac56fc-b2fa-4897-ba8b-1aa1b126ca9d	e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	${role_view-authorization}	view-authorization	438d433b-f366-40dc-9637-569f7d936a93	e7133bf8-32fa-476a-bddf-d92d4bad00e5	\N
0faf3f15-0792-416d-85c7-9733b4c856c6	e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	${role_manage-realm}	manage-realm	438d433b-f366-40dc-9637-569f7d936a93	e7133bf8-32fa-476a-bddf-d92d4bad00e5	\N
3c0c9197-d8d3-446d-b4ad-cc15134c1f02	e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	${role_manage-users}	manage-users	438d433b-f366-40dc-9637-569f7d936a93	e7133bf8-32fa-476a-bddf-d92d4bad00e5	\N
a0290f07-7922-4364-91f9-ace1abb0b075	e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	${role_manage-clients}	manage-clients	438d433b-f366-40dc-9637-569f7d936a93	e7133bf8-32fa-476a-bddf-d92d4bad00e5	\N
0c030ac4-2bcf-4f0b-8455-0030f81dde38	e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	${role_manage-events}	manage-events	438d433b-f366-40dc-9637-569f7d936a93	e7133bf8-32fa-476a-bddf-d92d4bad00e5	\N
a8161cb0-5d1a-413d-90cf-8e6ddb0f7e4a	e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	${role_manage-identity-providers}	manage-identity-providers	438d433b-f366-40dc-9637-569f7d936a93	e7133bf8-32fa-476a-bddf-d92d4bad00e5	\N
10b9c59b-a1e1-489e-9d11-a28e73e83b30	e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	${role_manage-authorization}	manage-authorization	438d433b-f366-40dc-9637-569f7d936a93	e7133bf8-32fa-476a-bddf-d92d4bad00e5	\N
8f85af81-f964-4bd9-931a-55474c0aa0de	e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	${role_query-users}	query-users	438d433b-f366-40dc-9637-569f7d936a93	e7133bf8-32fa-476a-bddf-d92d4bad00e5	\N
c9aad030-460e-4d0e-84f8-37ab952b127e	e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	${role_query-clients}	query-clients	438d433b-f366-40dc-9637-569f7d936a93	e7133bf8-32fa-476a-bddf-d92d4bad00e5	\N
b14f70cb-d633-4600-8ac4-57cfb7843332	e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	${role_query-realms}	query-realms	438d433b-f366-40dc-9637-569f7d936a93	e7133bf8-32fa-476a-bddf-d92d4bad00e5	\N
04e80505-68a1-498b-b3c9-1dc3d802ad43	e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	${role_query-groups}	query-groups	438d433b-f366-40dc-9637-569f7d936a93	e7133bf8-32fa-476a-bddf-d92d4bad00e5	\N
70527b68-e3ae-42f7-ad6b-63f97896c391	3d9f9d92-d9c3-4841-bac2-53911dd04736	t	${role_view-profile}	view-profile	438d433b-f366-40dc-9637-569f7d936a93	3d9f9d92-d9c3-4841-bac2-53911dd04736	\N
16f404a0-ef99-4409-b4bb-b460d972dcca	3d9f9d92-d9c3-4841-bac2-53911dd04736	t	${role_manage-account}	manage-account	438d433b-f366-40dc-9637-569f7d936a93	3d9f9d92-d9c3-4841-bac2-53911dd04736	\N
06599950-2290-4fe9-b0c7-99f1a86cc12b	3d9f9d92-d9c3-4841-bac2-53911dd04736	t	${role_manage-account-links}	manage-account-links	438d433b-f366-40dc-9637-569f7d936a93	3d9f9d92-d9c3-4841-bac2-53911dd04736	\N
6061ce1a-2486-4a9a-8afe-1c9e97a692fa	3d9f9d92-d9c3-4841-bac2-53911dd04736	t	${role_view-applications}	view-applications	438d433b-f366-40dc-9637-569f7d936a93	3d9f9d92-d9c3-4841-bac2-53911dd04736	\N
60ed1d1f-3ec7-41dd-a944-ee81f0fed109	3d9f9d92-d9c3-4841-bac2-53911dd04736	t	${role_view-consent}	view-consent	438d433b-f366-40dc-9637-569f7d936a93	3d9f9d92-d9c3-4841-bac2-53911dd04736	\N
38bd1d58-2b02-4fb5-9702-dfecc7750cf9	3d9f9d92-d9c3-4841-bac2-53911dd04736	t	${role_manage-consent}	manage-consent	438d433b-f366-40dc-9637-569f7d936a93	3d9f9d92-d9c3-4841-bac2-53911dd04736	\N
efb235ed-50d3-42e3-b99d-e567c7ecad36	3d9f9d92-d9c3-4841-bac2-53911dd04736	t	${role_view-groups}	view-groups	438d433b-f366-40dc-9637-569f7d936a93	3d9f9d92-d9c3-4841-bac2-53911dd04736	\N
834ee301-4968-43ce-aa0b-6222da871e69	3d9f9d92-d9c3-4841-bac2-53911dd04736	t	${role_delete-account}	delete-account	438d433b-f366-40dc-9637-569f7d936a93	3d9f9d92-d9c3-4841-bac2-53911dd04736	\N
8201e09e-126c-41fa-b965-b7f1c22447da	542c9876-d5a0-4a9a-bf9a-2756cb92cfab	t	${role_read-token}	read-token	438d433b-f366-40dc-9637-569f7d936a93	542c9876-d5a0-4a9a-bf9a-2756cb92cfab	\N
c7fd5ba7-34e1-43b8-b805-f6ddea5c6653	e7133bf8-32fa-476a-bddf-d92d4bad00e5	t	${role_impersonation}	impersonation	438d433b-f366-40dc-9637-569f7d936a93	e7133bf8-32fa-476a-bddf-d92d4bad00e5	\N
4f6dcbf3-e910-4786-9801-de3eaa4a6070	438d433b-f366-40dc-9637-569f7d936a93	f	${role_offline-access}	offline_access	438d433b-f366-40dc-9637-569f7d936a93	\N	\N
47f2d364-33a2-4b6e-8c65-90b66be3ba6f	438d433b-f366-40dc-9637-569f7d936a93	f	${role_uma_authorization}	uma_authorization	438d433b-f366-40dc-9637-569f7d936a93	\N	\N
cf14231c-140c-4652-a5d6-27522144626a	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	f	${role_default-roles}	default-roles-example	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	\N	\N
857a7058-8cf7-42e0-9c06-024b898eea5d	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	${role_create-client}	create-client	438d433b-f366-40dc-9637-569f7d936a93	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	\N
fb87b87a-e9fe-4d05-b7c4-317e13464e0c	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	${role_view-realm}	view-realm	438d433b-f366-40dc-9637-569f7d936a93	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	\N
e015c760-61a9-45af-ba40-927a31bee687	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	${role_view-users}	view-users	438d433b-f366-40dc-9637-569f7d936a93	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	\N
2c4d9735-4529-47c6-97cd-618c3e9e8112	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	${role_view-clients}	view-clients	438d433b-f366-40dc-9637-569f7d936a93	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	\N
1c3be4f3-59c9-4970-acef-04830b749197	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	${role_view-events}	view-events	438d433b-f366-40dc-9637-569f7d936a93	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	\N
07078bc8-63d4-4512-b191-3f91586827de	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	${role_view-identity-providers}	view-identity-providers	438d433b-f366-40dc-9637-569f7d936a93	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	\N
64cb8900-c38c-4e81-a6fb-1f9e670cdc95	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	${role_view-authorization}	view-authorization	438d433b-f366-40dc-9637-569f7d936a93	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	\N
a42059e1-930c-42e7-bd73-ccc1a8b61207	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	${role_manage-realm}	manage-realm	438d433b-f366-40dc-9637-569f7d936a93	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	\N
2d576204-2ca1-4095-872f-ca7e744c0822	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	${role_manage-users}	manage-users	438d433b-f366-40dc-9637-569f7d936a93	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	\N
8b229319-e238-4837-9272-6e90d10c6016	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	${role_manage-clients}	manage-clients	438d433b-f366-40dc-9637-569f7d936a93	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	\N
69a75e20-6900-49e4-b6ce-408a869e99cb	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	${role_manage-events}	manage-events	438d433b-f366-40dc-9637-569f7d936a93	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	\N
6c6bded7-9c00-4870-b66b-8406531922ad	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	${role_manage-identity-providers}	manage-identity-providers	438d433b-f366-40dc-9637-569f7d936a93	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	\N
44266fa4-f67d-4406-a6a9-09e528b8f18a	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	${role_manage-authorization}	manage-authorization	438d433b-f366-40dc-9637-569f7d936a93	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	\N
5301f743-3edf-42f9-bd7f-50bc8378f19c	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	${role_query-users}	query-users	438d433b-f366-40dc-9637-569f7d936a93	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	\N
780596a5-f019-4ca7-ae5f-466f111e86ea	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	${role_query-clients}	query-clients	438d433b-f366-40dc-9637-569f7d936a93	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	\N
9ee436aa-aed3-4de0-96ea-ddb41f76db41	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	${role_query-realms}	query-realms	438d433b-f366-40dc-9637-569f7d936a93	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	\N
05585f82-4cba-44ff-98bb-2e98e573ed09	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	${role_query-groups}	query-groups	438d433b-f366-40dc-9637-569f7d936a93	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	\N
04520e91-5798-4fc1-adf0-8ba6c7b94a0c	aa02c448-ca19-4536-b130-693b671d471d	t	${role_realm-admin}	realm-admin	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
c583a05b-ff62-415c-9cc1-552d72b8fca5	aa02c448-ca19-4536-b130-693b671d471d	t	${role_create-client}	create-client	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
2a667b6d-f0fa-45a9-b7cc-5bdcdc88f5bf	aa02c448-ca19-4536-b130-693b671d471d	t	${role_view-realm}	view-realm	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
d8ca7186-57a7-4777-b10e-1ad1b4966d0d	aa02c448-ca19-4536-b130-693b671d471d	t	${role_view-users}	view-users	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
c4d04fa5-8849-4ef3-8b40-78e4da59ecc1	aa02c448-ca19-4536-b130-693b671d471d	t	${role_view-clients}	view-clients	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
9eda0300-7f09-4e12-a6ef-1c21cfef6334	aa02c448-ca19-4536-b130-693b671d471d	t	${role_view-events}	view-events	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
5c0cf5a0-f050-4a36-a34f-8ed870b7527c	aa02c448-ca19-4536-b130-693b671d471d	t	${role_view-identity-providers}	view-identity-providers	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
d51fc16f-c111-4611-b8a1-c38f92f28e0a	aa02c448-ca19-4536-b130-693b671d471d	t	${role_view-authorization}	view-authorization	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
c135ccb0-e9fe-4409-95ea-372d7cef7fc1	aa02c448-ca19-4536-b130-693b671d471d	t	${role_manage-realm}	manage-realm	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
d5145725-1d3d-4251-a137-d587f690218e	aa02c448-ca19-4536-b130-693b671d471d	t	${role_manage-users}	manage-users	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
44a1b9ab-d8ed-478b-8695-af28ee426d56	aa02c448-ca19-4536-b130-693b671d471d	t	${role_manage-clients}	manage-clients	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
3d8640d2-20fd-400f-b0e3-adf60cf8d055	aa02c448-ca19-4536-b130-693b671d471d	t	${role_manage-events}	manage-events	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
a1bbf1b3-5d4f-408c-b605-66e246bd8dbe	aa02c448-ca19-4536-b130-693b671d471d	t	${role_manage-identity-providers}	manage-identity-providers	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
aa2e0f01-8360-45a8-a5c7-c259466f8d86	aa02c448-ca19-4536-b130-693b671d471d	t	${role_manage-authorization}	manage-authorization	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
12f67ea1-6569-4704-945b-12234cf4318f	aa02c448-ca19-4536-b130-693b671d471d	t	${role_query-users}	query-users	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
48d4eff0-15bd-49f3-b9be-fc2143c25e1d	aa02c448-ca19-4536-b130-693b671d471d	t	${role_query-clients}	query-clients	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
e3cfe99c-e2e0-493c-be65-f03f6f8b499b	aa02c448-ca19-4536-b130-693b671d471d	t	${role_query-realms}	query-realms	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
99c12a94-2670-47a8-a203-6111dbd15c70	aa02c448-ca19-4536-b130-693b671d471d	t	${role_query-groups}	query-groups	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
b8584074-2d43-4063-8b1b-eabd160afc1a	b1a916a4-2007-45c9-8319-855c86912a45	t	${role_view-profile}	view-profile	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	b1a916a4-2007-45c9-8319-855c86912a45	\N
b8d13099-955f-4945-a9a5-d67e60edc5c5	b1a916a4-2007-45c9-8319-855c86912a45	t	${role_manage-account}	manage-account	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	b1a916a4-2007-45c9-8319-855c86912a45	\N
7c78d3ee-5655-45c0-88a8-479b047aa976	b1a916a4-2007-45c9-8319-855c86912a45	t	${role_manage-account-links}	manage-account-links	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	b1a916a4-2007-45c9-8319-855c86912a45	\N
72126df4-e993-4c9e-b284-fb186f13a2dd	b1a916a4-2007-45c9-8319-855c86912a45	t	${role_view-applications}	view-applications	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	b1a916a4-2007-45c9-8319-855c86912a45	\N
37035570-db88-4f4a-9c43-8496abe34bfe	b1a916a4-2007-45c9-8319-855c86912a45	t	${role_view-consent}	view-consent	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	b1a916a4-2007-45c9-8319-855c86912a45	\N
87259851-a530-4845-8a96-b2d5427aa9e6	b1a916a4-2007-45c9-8319-855c86912a45	t	${role_manage-consent}	manage-consent	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	b1a916a4-2007-45c9-8319-855c86912a45	\N
6316d4d6-39a5-4b63-8ee1-b47c266cee14	b1a916a4-2007-45c9-8319-855c86912a45	t	${role_view-groups}	view-groups	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	b1a916a4-2007-45c9-8319-855c86912a45	\N
fc9c9eb8-8fe6-4f9e-868b-1e3e3a38c5a1	b1a916a4-2007-45c9-8319-855c86912a45	t	${role_delete-account}	delete-account	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	b1a916a4-2007-45c9-8319-855c86912a45	\N
050ca202-d92d-4258-b30b-3c553196a854	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	t	${role_impersonation}	impersonation	438d433b-f366-40dc-9637-569f7d936a93	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	\N
3903a887-4c6f-4391-a5bc-91477a9e2938	aa02c448-ca19-4536-b130-693b671d471d	t	${role_impersonation}	impersonation	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	aa02c448-ca19-4536-b130-693b671d471d	\N
d0ed1ff1-3eb2-4844-89be-c7e16123b3b5	a939956d-9f15-43f9-825f-491b8e676e8d	t	${role_read-token}	read-token	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	a939956d-9f15-43f9-825f-491b8e676e8d	\N
5c39235a-6e41-4b79-8ea9-5e8a9c4c2427	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	f	${role_offline-access}	offline_access	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	\N	\N
4df3683d-1f34-42c8-ae4f-ba0618355ba7	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	f	${role_uma_authorization}	uma_authorization	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	\N	\N
8347d537-33fd-4a01-9d02-c45ad64c6185	538f0243-e35c-48c0-a255-b7c964a03715	t	\N	uma_protection	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	538f0243-e35c-48c0-a255-b7c964a03715	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.migration_model (id, version, update_time) FROM stdin;
6lwny	23.0.6	1709901011
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
94d88ef1-3c93-44af-98b0-77908cb42851	code	// by default, grants any permission associated with this policy\n$evaluation.grant();\n
478786ec-cdd8-4d59-ac93-0860e12d11b9	defaultResourceType	urn:app:resources:default
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
3bc8bb37-f037-4e61-86d1-6d9f8389a320	audience resolve	openid-connect	oidc-audience-resolve-mapper	7ef93169-e5b2-4ab7-89a6-7a2a555b443f	\N
576758d2-ff17-40d5-bf5d-56bb2d0d9fa6	locale	openid-connect	oidc-usermodel-attribute-mapper	d3bccb88-8868-44c1-a6d8-bfa0109aa68d	\N
33cfbe05-dfad-4c92-8df8-42896893c269	role list	saml	saml-role-list-mapper	\N	806e1e50-749a-4afe-af19-1885b9a6527e
e00f9631-2c22-411c-86f0-6ebbe6306556	full name	openid-connect	oidc-full-name-mapper	\N	5c3a75d8-4031-41ca-b7c2-f57016ac6e88
7291b651-e6a8-486d-b122-ad1de655aacb	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	5c3a75d8-4031-41ca-b7c2-f57016ac6e88
b857c0ec-3856-4eed-8bed-244d8fccec10	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	5c3a75d8-4031-41ca-b7c2-f57016ac6e88
73d808a4-bbbf-41ab-a8ca-9ebcffda1731	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	5c3a75d8-4031-41ca-b7c2-f57016ac6e88
df4f6190-874e-4475-829f-013489285f00	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	5c3a75d8-4031-41ca-b7c2-f57016ac6e88
2514125c-44be-48f8-af67-2e8e060eae39	username	openid-connect	oidc-usermodel-attribute-mapper	\N	5c3a75d8-4031-41ca-b7c2-f57016ac6e88
0e005952-dd61-495f-a1fe-30b988d0d6ed	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	5c3a75d8-4031-41ca-b7c2-f57016ac6e88
e5568f18-356f-4039-89fd-4f1427518f53	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	5c3a75d8-4031-41ca-b7c2-f57016ac6e88
f32b4eaa-3295-48f7-8ae9-103f04eb5b7d	website	openid-connect	oidc-usermodel-attribute-mapper	\N	5c3a75d8-4031-41ca-b7c2-f57016ac6e88
8b9ccc37-496b-4bdf-8fb8-d9759edf6484	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	5c3a75d8-4031-41ca-b7c2-f57016ac6e88
fc50b27c-ff53-4bc4-a34a-db4b2eea3dc6	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	5c3a75d8-4031-41ca-b7c2-f57016ac6e88
b2fc50ed-6e69-405e-9ffc-8f266f29e485	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	5c3a75d8-4031-41ca-b7c2-f57016ac6e88
7cce44ef-889d-4e71-a4f1-88b7361f11e4	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	5c3a75d8-4031-41ca-b7c2-f57016ac6e88
b971e2c9-c80d-4bdb-8d77-4173473d93a6	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	5c3a75d8-4031-41ca-b7c2-f57016ac6e88
bb0dd75d-4335-414d-a365-4ac56040cb07	email	openid-connect	oidc-usermodel-attribute-mapper	\N	8628575a-2ac6-4af6-9921-b4744adeafdf
e5b24f0c-ed25-4802-8342-a8a1746ecbdb	email verified	openid-connect	oidc-usermodel-property-mapper	\N	8628575a-2ac6-4af6-9921-b4744adeafdf
bf01bce7-0234-4e34-b2c2-78e24ef372b3	address	openid-connect	oidc-address-mapper	\N	9bb8c391-26a7-4069-b9a7-2c6265738c82
ad0a6563-7571-402c-915b-4be53731f06e	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	15e0944d-c431-433e-afc6-720344ab3fe2
49f0c936-c311-4454-a126-1f708f07b207	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	15e0944d-c431-433e-afc6-720344ab3fe2
58ff2fad-cf0d-4799-ab33-f27b50e1dd97	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	e2b5e15d-bcd9-473a-a91c-61a1dfa5450d
93f44555-c298-49ba-8beb-9e74aa388d2f	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	e2b5e15d-bcd9-473a-a91c-61a1dfa5450d
f7a3bbae-509b-48cb-a534-b1d9cc0eabb4	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	e2b5e15d-bcd9-473a-a91c-61a1dfa5450d
b195f2f1-5382-4a69-9573-887f55f34b88	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	39210741-116c-4842-9f99-a3393f95c4a8
a95a79d6-d60b-431b-9551-120b4ac9d86c	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	a6a8e1c1-a62b-48e9-8b38-2cb8fa272747
9fd78611-5ed1-470d-a724-0da042cae66c	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	a6a8e1c1-a62b-48e9-8b38-2cb8fa272747
d3af89aa-cb82-4c0e-8469-cab9734b6d90	acr loa level	openid-connect	oidc-acr-mapper	\N	37c3e3aa-47d8-4834-af51-6a46a287e727
8917ca96-d213-42d7-b806-0979fb03abe1	audience resolve	openid-connect	oidc-audience-resolve-mapper	0690e5c3-bdc8-4282-9122-b40b38ac6dcb	\N
1e6f5311-1166-4130-9d0d-4de9c6dacd5e	role list	saml	saml-role-list-mapper	\N	ae8cd3ea-c159-4109-a4d5-9a1769991259
864254fd-f13c-4df8-9729-5adfd85a486f	full name	openid-connect	oidc-full-name-mapper	\N	fb340605-a470-4668-b6bb-491ffb2b1ab6
eb5aa07c-e20f-4bb7-9de6-00c11d622adb	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	fb340605-a470-4668-b6bb-491ffb2b1ab6
59f4485d-b4b3-475b-8542-c1a21f7c9452	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	fb340605-a470-4668-b6bb-491ffb2b1ab6
352d339f-1ab2-45eb-be3c-605faace25f5	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	fb340605-a470-4668-b6bb-491ffb2b1ab6
c167d78a-caf6-4fd2-895d-02613f75cb7a	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	fb340605-a470-4668-b6bb-491ffb2b1ab6
4a9899ff-6915-4f00-b61c-c8052fa73a88	username	openid-connect	oidc-usermodel-attribute-mapper	\N	fb340605-a470-4668-b6bb-491ffb2b1ab6
b42f6a1c-b294-4c4f-a9fe-34a51ddfc3de	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	fb340605-a470-4668-b6bb-491ffb2b1ab6
8e13eeb3-8c4f-4075-9f6e-23eac3d50fa7	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	fb340605-a470-4668-b6bb-491ffb2b1ab6
5d0b561b-497d-4d4f-94eb-49b898891a47	website	openid-connect	oidc-usermodel-attribute-mapper	\N	fb340605-a470-4668-b6bb-491ffb2b1ab6
a0e7a0d0-abe2-487f-8ac8-344156c1d10a	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	fb340605-a470-4668-b6bb-491ffb2b1ab6
4f557abd-659c-4e44-85d2-49951013678c	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	fb340605-a470-4668-b6bb-491ffb2b1ab6
680c7768-1bd5-4968-9db1-175403af8cea	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	fb340605-a470-4668-b6bb-491ffb2b1ab6
c573bb5f-6f65-494e-ba21-7482410f946f	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	fb340605-a470-4668-b6bb-491ffb2b1ab6
ffa0c9ce-ca1b-4a08-bae0-6ae5b45e88f7	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	fb340605-a470-4668-b6bb-491ffb2b1ab6
0707a4bb-92f9-401e-a835-0d46b96b4490	email	openid-connect	oidc-usermodel-attribute-mapper	\N	ed9f1561-b7c5-4ef4-a123-59413fb97e9e
105d29ac-1771-4be0-864f-334f2af9a803	email verified	openid-connect	oidc-usermodel-property-mapper	\N	ed9f1561-b7c5-4ef4-a123-59413fb97e9e
25d40a37-8950-4664-aeb4-a92f8a4ae5d6	address	openid-connect	oidc-address-mapper	\N	d952f795-e55f-4f44-9b01-7afb4e0497c1
88528296-3619-4d7f-9475-162d6b24a6c0	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	ee481d9d-1f07-44af-bef5-69b4beb1c762
6b6a2d7d-9804-45a0-95ca-ba9bb3660ada	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	ee481d9d-1f07-44af-bef5-69b4beb1c762
491f2c77-2daa-491b-91d5-63750ab683cf	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	24797bf1-e2a9-45af-b1aa-597dc4a8cbf0
38974834-175b-458e-98e7-1d688d3c19d6	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	24797bf1-e2a9-45af-b1aa-597dc4a8cbf0
8a4441dc-2307-4f5d-9446-92da8446e831	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	24797bf1-e2a9-45af-b1aa-597dc4a8cbf0
e6778862-87ab-4b16-a9fb-eaec5c84fc01	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	89cb8f94-6c38-4712-a712-d511e9c26fbc
b457d5e3-9681-412e-9644-97506bfa543e	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	5a42ce5e-105b-433f-bd81-8646190ed523
22cb4452-3ddb-4517-b5a9-111f6fb394bf	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	5a42ce5e-105b-433f-bd81-8646190ed523
949618ef-abdd-4d6b-b2ab-23a4970ad49b	acr loa level	openid-connect	oidc-acr-mapper	\N	cebe2803-77df-4640-b7c1-4a32faa5dd94
f320ca16-3333-493c-95ec-cb34c89718ff	locale	openid-connect	oidc-usermodel-attribute-mapper	98422c57-622e-41c2-874c-22bdf43d32ee	\N
4fd1ea00-f91e-48c9-bbbe-909ee8ab7a32	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	538f0243-e35c-48c0-a255-b7c964a03715	\N
138493a0-6120-4f68-87a5-1005b3e9a34f	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	538f0243-e35c-48c0-a255-b7c964a03715	\N
f1d5656e-c8e9-4504-9c49-478ed55cd2ef	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	538f0243-e35c-48c0-a255-b7c964a03715	\N
986ee732-7cd9-4e37-876a-4e6aaa0e6a74	groups	openid-connect	oidc-usermodel-realm-role-mapper	538f0243-e35c-48c0-a255-b7c964a03715	\N
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
576758d2-ff17-40d5-bf5d-56bb2d0d9fa6	true	introspection.token.claim
576758d2-ff17-40d5-bf5d-56bb2d0d9fa6	true	userinfo.token.claim
576758d2-ff17-40d5-bf5d-56bb2d0d9fa6	locale	user.attribute
576758d2-ff17-40d5-bf5d-56bb2d0d9fa6	true	id.token.claim
576758d2-ff17-40d5-bf5d-56bb2d0d9fa6	true	access.token.claim
576758d2-ff17-40d5-bf5d-56bb2d0d9fa6	locale	claim.name
576758d2-ff17-40d5-bf5d-56bb2d0d9fa6	String	jsonType.label
33cfbe05-dfad-4c92-8df8-42896893c269	false	single
33cfbe05-dfad-4c92-8df8-42896893c269	Basic	attribute.nameformat
33cfbe05-dfad-4c92-8df8-42896893c269	Role	attribute.name
0e005952-dd61-495f-a1fe-30b988d0d6ed	true	introspection.token.claim
0e005952-dd61-495f-a1fe-30b988d0d6ed	true	userinfo.token.claim
0e005952-dd61-495f-a1fe-30b988d0d6ed	profile	user.attribute
0e005952-dd61-495f-a1fe-30b988d0d6ed	true	id.token.claim
0e005952-dd61-495f-a1fe-30b988d0d6ed	true	access.token.claim
0e005952-dd61-495f-a1fe-30b988d0d6ed	profile	claim.name
0e005952-dd61-495f-a1fe-30b988d0d6ed	String	jsonType.label
2514125c-44be-48f8-af67-2e8e060eae39	true	introspection.token.claim
2514125c-44be-48f8-af67-2e8e060eae39	true	userinfo.token.claim
2514125c-44be-48f8-af67-2e8e060eae39	username	user.attribute
2514125c-44be-48f8-af67-2e8e060eae39	true	id.token.claim
2514125c-44be-48f8-af67-2e8e060eae39	true	access.token.claim
2514125c-44be-48f8-af67-2e8e060eae39	preferred_username	claim.name
2514125c-44be-48f8-af67-2e8e060eae39	String	jsonType.label
7291b651-e6a8-486d-b122-ad1de655aacb	true	introspection.token.claim
7291b651-e6a8-486d-b122-ad1de655aacb	true	userinfo.token.claim
7291b651-e6a8-486d-b122-ad1de655aacb	lastName	user.attribute
7291b651-e6a8-486d-b122-ad1de655aacb	true	id.token.claim
7291b651-e6a8-486d-b122-ad1de655aacb	true	access.token.claim
7291b651-e6a8-486d-b122-ad1de655aacb	family_name	claim.name
7291b651-e6a8-486d-b122-ad1de655aacb	String	jsonType.label
73d808a4-bbbf-41ab-a8ca-9ebcffda1731	true	introspection.token.claim
73d808a4-bbbf-41ab-a8ca-9ebcffda1731	true	userinfo.token.claim
73d808a4-bbbf-41ab-a8ca-9ebcffda1731	middleName	user.attribute
73d808a4-bbbf-41ab-a8ca-9ebcffda1731	true	id.token.claim
73d808a4-bbbf-41ab-a8ca-9ebcffda1731	true	access.token.claim
73d808a4-bbbf-41ab-a8ca-9ebcffda1731	middle_name	claim.name
73d808a4-bbbf-41ab-a8ca-9ebcffda1731	String	jsonType.label
7cce44ef-889d-4e71-a4f1-88b7361f11e4	true	introspection.token.claim
7cce44ef-889d-4e71-a4f1-88b7361f11e4	true	userinfo.token.claim
7cce44ef-889d-4e71-a4f1-88b7361f11e4	locale	user.attribute
7cce44ef-889d-4e71-a4f1-88b7361f11e4	true	id.token.claim
7cce44ef-889d-4e71-a4f1-88b7361f11e4	true	access.token.claim
7cce44ef-889d-4e71-a4f1-88b7361f11e4	locale	claim.name
7cce44ef-889d-4e71-a4f1-88b7361f11e4	String	jsonType.label
8b9ccc37-496b-4bdf-8fb8-d9759edf6484	true	introspection.token.claim
8b9ccc37-496b-4bdf-8fb8-d9759edf6484	true	userinfo.token.claim
8b9ccc37-496b-4bdf-8fb8-d9759edf6484	gender	user.attribute
8b9ccc37-496b-4bdf-8fb8-d9759edf6484	true	id.token.claim
8b9ccc37-496b-4bdf-8fb8-d9759edf6484	true	access.token.claim
8b9ccc37-496b-4bdf-8fb8-d9759edf6484	gender	claim.name
8b9ccc37-496b-4bdf-8fb8-d9759edf6484	String	jsonType.label
b2fc50ed-6e69-405e-9ffc-8f266f29e485	true	introspection.token.claim
b2fc50ed-6e69-405e-9ffc-8f266f29e485	true	userinfo.token.claim
b2fc50ed-6e69-405e-9ffc-8f266f29e485	zoneinfo	user.attribute
b2fc50ed-6e69-405e-9ffc-8f266f29e485	true	id.token.claim
b2fc50ed-6e69-405e-9ffc-8f266f29e485	true	access.token.claim
b2fc50ed-6e69-405e-9ffc-8f266f29e485	zoneinfo	claim.name
b2fc50ed-6e69-405e-9ffc-8f266f29e485	String	jsonType.label
b857c0ec-3856-4eed-8bed-244d8fccec10	true	introspection.token.claim
b857c0ec-3856-4eed-8bed-244d8fccec10	true	userinfo.token.claim
b857c0ec-3856-4eed-8bed-244d8fccec10	firstName	user.attribute
b857c0ec-3856-4eed-8bed-244d8fccec10	true	id.token.claim
b857c0ec-3856-4eed-8bed-244d8fccec10	true	access.token.claim
b857c0ec-3856-4eed-8bed-244d8fccec10	given_name	claim.name
b857c0ec-3856-4eed-8bed-244d8fccec10	String	jsonType.label
b971e2c9-c80d-4bdb-8d77-4173473d93a6	true	introspection.token.claim
b971e2c9-c80d-4bdb-8d77-4173473d93a6	true	userinfo.token.claim
b971e2c9-c80d-4bdb-8d77-4173473d93a6	updatedAt	user.attribute
b971e2c9-c80d-4bdb-8d77-4173473d93a6	true	id.token.claim
b971e2c9-c80d-4bdb-8d77-4173473d93a6	true	access.token.claim
b971e2c9-c80d-4bdb-8d77-4173473d93a6	updated_at	claim.name
b971e2c9-c80d-4bdb-8d77-4173473d93a6	long	jsonType.label
df4f6190-874e-4475-829f-013489285f00	true	introspection.token.claim
df4f6190-874e-4475-829f-013489285f00	true	userinfo.token.claim
df4f6190-874e-4475-829f-013489285f00	nickname	user.attribute
df4f6190-874e-4475-829f-013489285f00	true	id.token.claim
df4f6190-874e-4475-829f-013489285f00	true	access.token.claim
df4f6190-874e-4475-829f-013489285f00	nickname	claim.name
df4f6190-874e-4475-829f-013489285f00	String	jsonType.label
e00f9631-2c22-411c-86f0-6ebbe6306556	true	introspection.token.claim
e00f9631-2c22-411c-86f0-6ebbe6306556	true	userinfo.token.claim
e00f9631-2c22-411c-86f0-6ebbe6306556	true	id.token.claim
e00f9631-2c22-411c-86f0-6ebbe6306556	true	access.token.claim
e5568f18-356f-4039-89fd-4f1427518f53	true	introspection.token.claim
e5568f18-356f-4039-89fd-4f1427518f53	true	userinfo.token.claim
e5568f18-356f-4039-89fd-4f1427518f53	picture	user.attribute
e5568f18-356f-4039-89fd-4f1427518f53	true	id.token.claim
e5568f18-356f-4039-89fd-4f1427518f53	true	access.token.claim
e5568f18-356f-4039-89fd-4f1427518f53	picture	claim.name
e5568f18-356f-4039-89fd-4f1427518f53	String	jsonType.label
f32b4eaa-3295-48f7-8ae9-103f04eb5b7d	true	introspection.token.claim
f32b4eaa-3295-48f7-8ae9-103f04eb5b7d	true	userinfo.token.claim
f32b4eaa-3295-48f7-8ae9-103f04eb5b7d	website	user.attribute
f32b4eaa-3295-48f7-8ae9-103f04eb5b7d	true	id.token.claim
f32b4eaa-3295-48f7-8ae9-103f04eb5b7d	true	access.token.claim
f32b4eaa-3295-48f7-8ae9-103f04eb5b7d	website	claim.name
f32b4eaa-3295-48f7-8ae9-103f04eb5b7d	String	jsonType.label
fc50b27c-ff53-4bc4-a34a-db4b2eea3dc6	true	introspection.token.claim
fc50b27c-ff53-4bc4-a34a-db4b2eea3dc6	true	userinfo.token.claim
fc50b27c-ff53-4bc4-a34a-db4b2eea3dc6	birthdate	user.attribute
fc50b27c-ff53-4bc4-a34a-db4b2eea3dc6	true	id.token.claim
fc50b27c-ff53-4bc4-a34a-db4b2eea3dc6	true	access.token.claim
fc50b27c-ff53-4bc4-a34a-db4b2eea3dc6	birthdate	claim.name
fc50b27c-ff53-4bc4-a34a-db4b2eea3dc6	String	jsonType.label
bb0dd75d-4335-414d-a365-4ac56040cb07	true	introspection.token.claim
bb0dd75d-4335-414d-a365-4ac56040cb07	true	userinfo.token.claim
bb0dd75d-4335-414d-a365-4ac56040cb07	email	user.attribute
bb0dd75d-4335-414d-a365-4ac56040cb07	true	id.token.claim
bb0dd75d-4335-414d-a365-4ac56040cb07	true	access.token.claim
bb0dd75d-4335-414d-a365-4ac56040cb07	email	claim.name
bb0dd75d-4335-414d-a365-4ac56040cb07	String	jsonType.label
e5b24f0c-ed25-4802-8342-a8a1746ecbdb	true	introspection.token.claim
e5b24f0c-ed25-4802-8342-a8a1746ecbdb	true	userinfo.token.claim
e5b24f0c-ed25-4802-8342-a8a1746ecbdb	emailVerified	user.attribute
e5b24f0c-ed25-4802-8342-a8a1746ecbdb	true	id.token.claim
e5b24f0c-ed25-4802-8342-a8a1746ecbdb	true	access.token.claim
e5b24f0c-ed25-4802-8342-a8a1746ecbdb	email_verified	claim.name
e5b24f0c-ed25-4802-8342-a8a1746ecbdb	boolean	jsonType.label
bf01bce7-0234-4e34-b2c2-78e24ef372b3	formatted	user.attribute.formatted
bf01bce7-0234-4e34-b2c2-78e24ef372b3	country	user.attribute.country
bf01bce7-0234-4e34-b2c2-78e24ef372b3	true	introspection.token.claim
bf01bce7-0234-4e34-b2c2-78e24ef372b3	postal_code	user.attribute.postal_code
bf01bce7-0234-4e34-b2c2-78e24ef372b3	true	userinfo.token.claim
bf01bce7-0234-4e34-b2c2-78e24ef372b3	street	user.attribute.street
bf01bce7-0234-4e34-b2c2-78e24ef372b3	true	id.token.claim
bf01bce7-0234-4e34-b2c2-78e24ef372b3	region	user.attribute.region
bf01bce7-0234-4e34-b2c2-78e24ef372b3	true	access.token.claim
bf01bce7-0234-4e34-b2c2-78e24ef372b3	locality	user.attribute.locality
49f0c936-c311-4454-a126-1f708f07b207	true	introspection.token.claim
49f0c936-c311-4454-a126-1f708f07b207	true	userinfo.token.claim
49f0c936-c311-4454-a126-1f708f07b207	phoneNumberVerified	user.attribute
49f0c936-c311-4454-a126-1f708f07b207	true	id.token.claim
49f0c936-c311-4454-a126-1f708f07b207	true	access.token.claim
49f0c936-c311-4454-a126-1f708f07b207	phone_number_verified	claim.name
49f0c936-c311-4454-a126-1f708f07b207	boolean	jsonType.label
ad0a6563-7571-402c-915b-4be53731f06e	true	introspection.token.claim
ad0a6563-7571-402c-915b-4be53731f06e	true	userinfo.token.claim
ad0a6563-7571-402c-915b-4be53731f06e	phoneNumber	user.attribute
ad0a6563-7571-402c-915b-4be53731f06e	true	id.token.claim
ad0a6563-7571-402c-915b-4be53731f06e	true	access.token.claim
ad0a6563-7571-402c-915b-4be53731f06e	phone_number	claim.name
ad0a6563-7571-402c-915b-4be53731f06e	String	jsonType.label
58ff2fad-cf0d-4799-ab33-f27b50e1dd97	true	introspection.token.claim
58ff2fad-cf0d-4799-ab33-f27b50e1dd97	true	multivalued
58ff2fad-cf0d-4799-ab33-f27b50e1dd97	foo	user.attribute
58ff2fad-cf0d-4799-ab33-f27b50e1dd97	true	access.token.claim
58ff2fad-cf0d-4799-ab33-f27b50e1dd97	realm_access.roles	claim.name
58ff2fad-cf0d-4799-ab33-f27b50e1dd97	String	jsonType.label
93f44555-c298-49ba-8beb-9e74aa388d2f	true	introspection.token.claim
93f44555-c298-49ba-8beb-9e74aa388d2f	true	multivalued
93f44555-c298-49ba-8beb-9e74aa388d2f	foo	user.attribute
93f44555-c298-49ba-8beb-9e74aa388d2f	true	access.token.claim
93f44555-c298-49ba-8beb-9e74aa388d2f	resource_access.${client_id}.roles	claim.name
93f44555-c298-49ba-8beb-9e74aa388d2f	String	jsonType.label
f7a3bbae-509b-48cb-a534-b1d9cc0eabb4	true	introspection.token.claim
f7a3bbae-509b-48cb-a534-b1d9cc0eabb4	true	access.token.claim
b195f2f1-5382-4a69-9573-887f55f34b88	true	introspection.token.claim
b195f2f1-5382-4a69-9573-887f55f34b88	true	access.token.claim
9fd78611-5ed1-470d-a724-0da042cae66c	true	introspection.token.claim
9fd78611-5ed1-470d-a724-0da042cae66c	true	multivalued
9fd78611-5ed1-470d-a724-0da042cae66c	foo	user.attribute
9fd78611-5ed1-470d-a724-0da042cae66c	true	id.token.claim
9fd78611-5ed1-470d-a724-0da042cae66c	true	access.token.claim
9fd78611-5ed1-470d-a724-0da042cae66c	groups	claim.name
9fd78611-5ed1-470d-a724-0da042cae66c	String	jsonType.label
a95a79d6-d60b-431b-9551-120b4ac9d86c	true	introspection.token.claim
a95a79d6-d60b-431b-9551-120b4ac9d86c	true	userinfo.token.claim
a95a79d6-d60b-431b-9551-120b4ac9d86c	username	user.attribute
a95a79d6-d60b-431b-9551-120b4ac9d86c	true	id.token.claim
a95a79d6-d60b-431b-9551-120b4ac9d86c	true	access.token.claim
a95a79d6-d60b-431b-9551-120b4ac9d86c	upn	claim.name
a95a79d6-d60b-431b-9551-120b4ac9d86c	String	jsonType.label
d3af89aa-cb82-4c0e-8469-cab9734b6d90	true	introspection.token.claim
d3af89aa-cb82-4c0e-8469-cab9734b6d90	true	id.token.claim
d3af89aa-cb82-4c0e-8469-cab9734b6d90	true	access.token.claim
1e6f5311-1166-4130-9d0d-4de9c6dacd5e	false	single
1e6f5311-1166-4130-9d0d-4de9c6dacd5e	Basic	attribute.nameformat
1e6f5311-1166-4130-9d0d-4de9c6dacd5e	Role	attribute.name
352d339f-1ab2-45eb-be3c-605faace25f5	true	introspection.token.claim
352d339f-1ab2-45eb-be3c-605faace25f5	true	userinfo.token.claim
352d339f-1ab2-45eb-be3c-605faace25f5	middleName	user.attribute
352d339f-1ab2-45eb-be3c-605faace25f5	true	id.token.claim
352d339f-1ab2-45eb-be3c-605faace25f5	true	access.token.claim
352d339f-1ab2-45eb-be3c-605faace25f5	middle_name	claim.name
352d339f-1ab2-45eb-be3c-605faace25f5	String	jsonType.label
4a9899ff-6915-4f00-b61c-c8052fa73a88	true	introspection.token.claim
4a9899ff-6915-4f00-b61c-c8052fa73a88	true	userinfo.token.claim
4a9899ff-6915-4f00-b61c-c8052fa73a88	username	user.attribute
4a9899ff-6915-4f00-b61c-c8052fa73a88	true	id.token.claim
4a9899ff-6915-4f00-b61c-c8052fa73a88	true	access.token.claim
4a9899ff-6915-4f00-b61c-c8052fa73a88	preferred_username	claim.name
4a9899ff-6915-4f00-b61c-c8052fa73a88	String	jsonType.label
4f557abd-659c-4e44-85d2-49951013678c	true	introspection.token.claim
4f557abd-659c-4e44-85d2-49951013678c	true	userinfo.token.claim
4f557abd-659c-4e44-85d2-49951013678c	birthdate	user.attribute
4f557abd-659c-4e44-85d2-49951013678c	true	id.token.claim
4f557abd-659c-4e44-85d2-49951013678c	true	access.token.claim
4f557abd-659c-4e44-85d2-49951013678c	birthdate	claim.name
4f557abd-659c-4e44-85d2-49951013678c	String	jsonType.label
59f4485d-b4b3-475b-8542-c1a21f7c9452	true	introspection.token.claim
59f4485d-b4b3-475b-8542-c1a21f7c9452	true	userinfo.token.claim
59f4485d-b4b3-475b-8542-c1a21f7c9452	firstName	user.attribute
59f4485d-b4b3-475b-8542-c1a21f7c9452	true	id.token.claim
59f4485d-b4b3-475b-8542-c1a21f7c9452	true	access.token.claim
59f4485d-b4b3-475b-8542-c1a21f7c9452	given_name	claim.name
59f4485d-b4b3-475b-8542-c1a21f7c9452	String	jsonType.label
5d0b561b-497d-4d4f-94eb-49b898891a47	true	introspection.token.claim
5d0b561b-497d-4d4f-94eb-49b898891a47	true	userinfo.token.claim
5d0b561b-497d-4d4f-94eb-49b898891a47	website	user.attribute
5d0b561b-497d-4d4f-94eb-49b898891a47	true	id.token.claim
5d0b561b-497d-4d4f-94eb-49b898891a47	true	access.token.claim
5d0b561b-497d-4d4f-94eb-49b898891a47	website	claim.name
5d0b561b-497d-4d4f-94eb-49b898891a47	String	jsonType.label
680c7768-1bd5-4968-9db1-175403af8cea	true	introspection.token.claim
680c7768-1bd5-4968-9db1-175403af8cea	true	userinfo.token.claim
680c7768-1bd5-4968-9db1-175403af8cea	zoneinfo	user.attribute
680c7768-1bd5-4968-9db1-175403af8cea	true	id.token.claim
680c7768-1bd5-4968-9db1-175403af8cea	true	access.token.claim
680c7768-1bd5-4968-9db1-175403af8cea	zoneinfo	claim.name
680c7768-1bd5-4968-9db1-175403af8cea	String	jsonType.label
864254fd-f13c-4df8-9729-5adfd85a486f	true	introspection.token.claim
864254fd-f13c-4df8-9729-5adfd85a486f	true	userinfo.token.claim
864254fd-f13c-4df8-9729-5adfd85a486f	true	id.token.claim
864254fd-f13c-4df8-9729-5adfd85a486f	true	access.token.claim
8e13eeb3-8c4f-4075-9f6e-23eac3d50fa7	true	introspection.token.claim
8e13eeb3-8c4f-4075-9f6e-23eac3d50fa7	true	userinfo.token.claim
8e13eeb3-8c4f-4075-9f6e-23eac3d50fa7	picture	user.attribute
8e13eeb3-8c4f-4075-9f6e-23eac3d50fa7	true	id.token.claim
8e13eeb3-8c4f-4075-9f6e-23eac3d50fa7	true	access.token.claim
8e13eeb3-8c4f-4075-9f6e-23eac3d50fa7	picture	claim.name
8e13eeb3-8c4f-4075-9f6e-23eac3d50fa7	String	jsonType.label
a0e7a0d0-abe2-487f-8ac8-344156c1d10a	true	introspection.token.claim
a0e7a0d0-abe2-487f-8ac8-344156c1d10a	true	userinfo.token.claim
a0e7a0d0-abe2-487f-8ac8-344156c1d10a	gender	user.attribute
a0e7a0d0-abe2-487f-8ac8-344156c1d10a	true	id.token.claim
a0e7a0d0-abe2-487f-8ac8-344156c1d10a	true	access.token.claim
a0e7a0d0-abe2-487f-8ac8-344156c1d10a	gender	claim.name
a0e7a0d0-abe2-487f-8ac8-344156c1d10a	String	jsonType.label
b42f6a1c-b294-4c4f-a9fe-34a51ddfc3de	true	introspection.token.claim
b42f6a1c-b294-4c4f-a9fe-34a51ddfc3de	true	userinfo.token.claim
b42f6a1c-b294-4c4f-a9fe-34a51ddfc3de	profile	user.attribute
b42f6a1c-b294-4c4f-a9fe-34a51ddfc3de	true	id.token.claim
b42f6a1c-b294-4c4f-a9fe-34a51ddfc3de	true	access.token.claim
b42f6a1c-b294-4c4f-a9fe-34a51ddfc3de	profile	claim.name
b42f6a1c-b294-4c4f-a9fe-34a51ddfc3de	String	jsonType.label
c167d78a-caf6-4fd2-895d-02613f75cb7a	true	introspection.token.claim
c167d78a-caf6-4fd2-895d-02613f75cb7a	true	userinfo.token.claim
c167d78a-caf6-4fd2-895d-02613f75cb7a	nickname	user.attribute
c167d78a-caf6-4fd2-895d-02613f75cb7a	true	id.token.claim
c167d78a-caf6-4fd2-895d-02613f75cb7a	true	access.token.claim
c167d78a-caf6-4fd2-895d-02613f75cb7a	nickname	claim.name
c167d78a-caf6-4fd2-895d-02613f75cb7a	String	jsonType.label
c573bb5f-6f65-494e-ba21-7482410f946f	true	introspection.token.claim
c573bb5f-6f65-494e-ba21-7482410f946f	true	userinfo.token.claim
c573bb5f-6f65-494e-ba21-7482410f946f	locale	user.attribute
c573bb5f-6f65-494e-ba21-7482410f946f	true	id.token.claim
c573bb5f-6f65-494e-ba21-7482410f946f	true	access.token.claim
c573bb5f-6f65-494e-ba21-7482410f946f	locale	claim.name
c573bb5f-6f65-494e-ba21-7482410f946f	String	jsonType.label
eb5aa07c-e20f-4bb7-9de6-00c11d622adb	true	introspection.token.claim
eb5aa07c-e20f-4bb7-9de6-00c11d622adb	true	userinfo.token.claim
eb5aa07c-e20f-4bb7-9de6-00c11d622adb	lastName	user.attribute
eb5aa07c-e20f-4bb7-9de6-00c11d622adb	true	id.token.claim
eb5aa07c-e20f-4bb7-9de6-00c11d622adb	true	access.token.claim
eb5aa07c-e20f-4bb7-9de6-00c11d622adb	family_name	claim.name
eb5aa07c-e20f-4bb7-9de6-00c11d622adb	String	jsonType.label
ffa0c9ce-ca1b-4a08-bae0-6ae5b45e88f7	true	introspection.token.claim
ffa0c9ce-ca1b-4a08-bae0-6ae5b45e88f7	true	userinfo.token.claim
ffa0c9ce-ca1b-4a08-bae0-6ae5b45e88f7	updatedAt	user.attribute
ffa0c9ce-ca1b-4a08-bae0-6ae5b45e88f7	true	id.token.claim
ffa0c9ce-ca1b-4a08-bae0-6ae5b45e88f7	true	access.token.claim
ffa0c9ce-ca1b-4a08-bae0-6ae5b45e88f7	updated_at	claim.name
ffa0c9ce-ca1b-4a08-bae0-6ae5b45e88f7	long	jsonType.label
0707a4bb-92f9-401e-a835-0d46b96b4490	true	introspection.token.claim
0707a4bb-92f9-401e-a835-0d46b96b4490	true	userinfo.token.claim
0707a4bb-92f9-401e-a835-0d46b96b4490	email	user.attribute
0707a4bb-92f9-401e-a835-0d46b96b4490	true	id.token.claim
0707a4bb-92f9-401e-a835-0d46b96b4490	true	access.token.claim
0707a4bb-92f9-401e-a835-0d46b96b4490	email	claim.name
0707a4bb-92f9-401e-a835-0d46b96b4490	String	jsonType.label
105d29ac-1771-4be0-864f-334f2af9a803	true	introspection.token.claim
105d29ac-1771-4be0-864f-334f2af9a803	true	userinfo.token.claim
105d29ac-1771-4be0-864f-334f2af9a803	emailVerified	user.attribute
105d29ac-1771-4be0-864f-334f2af9a803	true	id.token.claim
105d29ac-1771-4be0-864f-334f2af9a803	true	access.token.claim
105d29ac-1771-4be0-864f-334f2af9a803	email_verified	claim.name
105d29ac-1771-4be0-864f-334f2af9a803	boolean	jsonType.label
25d40a37-8950-4664-aeb4-a92f8a4ae5d6	formatted	user.attribute.formatted
25d40a37-8950-4664-aeb4-a92f8a4ae5d6	country	user.attribute.country
25d40a37-8950-4664-aeb4-a92f8a4ae5d6	true	introspection.token.claim
25d40a37-8950-4664-aeb4-a92f8a4ae5d6	postal_code	user.attribute.postal_code
25d40a37-8950-4664-aeb4-a92f8a4ae5d6	true	userinfo.token.claim
25d40a37-8950-4664-aeb4-a92f8a4ae5d6	street	user.attribute.street
25d40a37-8950-4664-aeb4-a92f8a4ae5d6	true	id.token.claim
25d40a37-8950-4664-aeb4-a92f8a4ae5d6	region	user.attribute.region
25d40a37-8950-4664-aeb4-a92f8a4ae5d6	true	access.token.claim
25d40a37-8950-4664-aeb4-a92f8a4ae5d6	locality	user.attribute.locality
6b6a2d7d-9804-45a0-95ca-ba9bb3660ada	true	introspection.token.claim
6b6a2d7d-9804-45a0-95ca-ba9bb3660ada	true	userinfo.token.claim
6b6a2d7d-9804-45a0-95ca-ba9bb3660ada	phoneNumberVerified	user.attribute
6b6a2d7d-9804-45a0-95ca-ba9bb3660ada	true	id.token.claim
6b6a2d7d-9804-45a0-95ca-ba9bb3660ada	true	access.token.claim
6b6a2d7d-9804-45a0-95ca-ba9bb3660ada	phone_number_verified	claim.name
6b6a2d7d-9804-45a0-95ca-ba9bb3660ada	boolean	jsonType.label
88528296-3619-4d7f-9475-162d6b24a6c0	true	introspection.token.claim
88528296-3619-4d7f-9475-162d6b24a6c0	true	userinfo.token.claim
88528296-3619-4d7f-9475-162d6b24a6c0	phoneNumber	user.attribute
88528296-3619-4d7f-9475-162d6b24a6c0	true	id.token.claim
88528296-3619-4d7f-9475-162d6b24a6c0	true	access.token.claim
88528296-3619-4d7f-9475-162d6b24a6c0	phone_number	claim.name
88528296-3619-4d7f-9475-162d6b24a6c0	String	jsonType.label
38974834-175b-458e-98e7-1d688d3c19d6	true	introspection.token.claim
38974834-175b-458e-98e7-1d688d3c19d6	true	multivalued
38974834-175b-458e-98e7-1d688d3c19d6	foo	user.attribute
38974834-175b-458e-98e7-1d688d3c19d6	true	access.token.claim
38974834-175b-458e-98e7-1d688d3c19d6	resource_access.${client_id}.roles	claim.name
38974834-175b-458e-98e7-1d688d3c19d6	String	jsonType.label
491f2c77-2daa-491b-91d5-63750ab683cf	true	introspection.token.claim
491f2c77-2daa-491b-91d5-63750ab683cf	true	multivalued
491f2c77-2daa-491b-91d5-63750ab683cf	foo	user.attribute
491f2c77-2daa-491b-91d5-63750ab683cf	true	access.token.claim
491f2c77-2daa-491b-91d5-63750ab683cf	realm_access.roles	claim.name
491f2c77-2daa-491b-91d5-63750ab683cf	String	jsonType.label
8a4441dc-2307-4f5d-9446-92da8446e831	true	introspection.token.claim
8a4441dc-2307-4f5d-9446-92da8446e831	true	access.token.claim
e6778862-87ab-4b16-a9fb-eaec5c84fc01	true	introspection.token.claim
e6778862-87ab-4b16-a9fb-eaec5c84fc01	true	access.token.claim
22cb4452-3ddb-4517-b5a9-111f6fb394bf	true	introspection.token.claim
22cb4452-3ddb-4517-b5a9-111f6fb394bf	true	multivalued
22cb4452-3ddb-4517-b5a9-111f6fb394bf	foo	user.attribute
22cb4452-3ddb-4517-b5a9-111f6fb394bf	true	id.token.claim
22cb4452-3ddb-4517-b5a9-111f6fb394bf	true	access.token.claim
22cb4452-3ddb-4517-b5a9-111f6fb394bf	groups	claim.name
22cb4452-3ddb-4517-b5a9-111f6fb394bf	String	jsonType.label
b457d5e3-9681-412e-9644-97506bfa543e	true	introspection.token.claim
b457d5e3-9681-412e-9644-97506bfa543e	true	userinfo.token.claim
b457d5e3-9681-412e-9644-97506bfa543e	username	user.attribute
b457d5e3-9681-412e-9644-97506bfa543e	true	id.token.claim
b457d5e3-9681-412e-9644-97506bfa543e	true	access.token.claim
b457d5e3-9681-412e-9644-97506bfa543e	upn	claim.name
b457d5e3-9681-412e-9644-97506bfa543e	String	jsonType.label
949618ef-abdd-4d6b-b2ab-23a4970ad49b	true	introspection.token.claim
949618ef-abdd-4d6b-b2ab-23a4970ad49b	true	id.token.claim
949618ef-abdd-4d6b-b2ab-23a4970ad49b	true	access.token.claim
f320ca16-3333-493c-95ec-cb34c89718ff	true	introspection.token.claim
f320ca16-3333-493c-95ec-cb34c89718ff	true	userinfo.token.claim
f320ca16-3333-493c-95ec-cb34c89718ff	locale	user.attribute
f320ca16-3333-493c-95ec-cb34c89718ff	true	id.token.claim
f320ca16-3333-493c-95ec-cb34c89718ff	true	access.token.claim
f320ca16-3333-493c-95ec-cb34c89718ff	locale	claim.name
f320ca16-3333-493c-95ec-cb34c89718ff	String	jsonType.label
138493a0-6120-4f68-87a5-1005b3e9a34f	clientHost	user.session.note
138493a0-6120-4f68-87a5-1005b3e9a34f	true	introspection.token.claim
138493a0-6120-4f68-87a5-1005b3e9a34f	true	id.token.claim
138493a0-6120-4f68-87a5-1005b3e9a34f	true	access.token.claim
138493a0-6120-4f68-87a5-1005b3e9a34f	clientHost	claim.name
138493a0-6120-4f68-87a5-1005b3e9a34f	String	jsonType.label
4fd1ea00-f91e-48c9-bbbe-909ee8ab7a32	client_id	user.session.note
4fd1ea00-f91e-48c9-bbbe-909ee8ab7a32	true	introspection.token.claim
4fd1ea00-f91e-48c9-bbbe-909ee8ab7a32	true	id.token.claim
4fd1ea00-f91e-48c9-bbbe-909ee8ab7a32	true	access.token.claim
4fd1ea00-f91e-48c9-bbbe-909ee8ab7a32	client_id	claim.name
4fd1ea00-f91e-48c9-bbbe-909ee8ab7a32	String	jsonType.label
f1d5656e-c8e9-4504-9c49-478ed55cd2ef	clientAddress	user.session.note
f1d5656e-c8e9-4504-9c49-478ed55cd2ef	true	introspection.token.claim
f1d5656e-c8e9-4504-9c49-478ed55cd2ef	true	id.token.claim
f1d5656e-c8e9-4504-9c49-478ed55cd2ef	true	access.token.claim
f1d5656e-c8e9-4504-9c49-478ed55cd2ef	clientAddress	claim.name
f1d5656e-c8e9-4504-9c49-478ed55cd2ef	String	jsonType.label
986ee732-7cd9-4e37-876a-4e6aaa0e6a74	true	introspection.token.claim
986ee732-7cd9-4e37-876a-4e6aaa0e6a74	true	multivalued
986ee732-7cd9-4e37-876a-4e6aaa0e6a74	foo	user.attribute
986ee732-7cd9-4e37-876a-4e6aaa0e6a74	true	id.token.claim
986ee732-7cd9-4e37-876a-4e6aaa0e6a74	true	access.token.claim
986ee732-7cd9-4e37-876a-4e6aaa0e6a74	groups	claim.name
986ee732-7cd9-4e37-876a-4e6aaa0e6a74	String	jsonType.label
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
438d433b-f366-40dc-9637-569f7d936a93	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	e7133bf8-32fa-476a-bddf-d92d4bad00e5	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	393bb45d-51a1-46f6-86f1-b94f85742f4b	f742377e-5e60-4000-85eb-44d78c56a3fa	2191c7fc-f097-4c93-81cc-6b2b44bc55d4	2accab68-d7fd-4640-8511-c062c7343c55	f6babe83-dcab-4576-a90c-46baccec3ce8	2592000	f	900	t	f	1010734e-e783-4034-995b-15ba13aebc1d	0	f	0	0	e8871570-ca3d-436d-813a-12ee4acd8c21
a465077b-0c7f-4fcc-bf69-d3f0805cefe5	60	300	300	\N	\N	\N	t	f	0	\N	example	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	83162fe3-b6c6-4c21-b4ce-bdf24e76a452	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	c929bf54-38ff-472b-9dc5-8187f2b0643a	30512607-f784-4a59-bf06-cddbaa5f4735	d64f6d15-326d-4322-a342-11af8b516c1e	fd2351e2-cc7e-49cf-a403-11cb58e03fce	7fca25ec-2f81-48ca-b239-241124e5dc4f	2592000	f	900	t	f	4dace6b7-f326-4a41-ae41-cfc83b6ff9be	0	f	0	0	cf14231c-140c-4652-a5d6-27522144626a
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	438d433b-f366-40dc-9637-569f7d936a93	
_browser_header.xContentTypeOptions	438d433b-f366-40dc-9637-569f7d936a93	nosniff
_browser_header.referrerPolicy	438d433b-f366-40dc-9637-569f7d936a93	no-referrer
_browser_header.xRobotsTag	438d433b-f366-40dc-9637-569f7d936a93	none
_browser_header.xFrameOptions	438d433b-f366-40dc-9637-569f7d936a93	SAMEORIGIN
_browser_header.contentSecurityPolicy	438d433b-f366-40dc-9637-569f7d936a93	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	438d433b-f366-40dc-9637-569f7d936a93	1; mode=block
_browser_header.strictTransportSecurity	438d433b-f366-40dc-9637-569f7d936a93	max-age=31536000; includeSubDomains
bruteForceProtected	438d433b-f366-40dc-9637-569f7d936a93	false
permanentLockout	438d433b-f366-40dc-9637-569f7d936a93	false
maxFailureWaitSeconds	438d433b-f366-40dc-9637-569f7d936a93	900
minimumQuickLoginWaitSeconds	438d433b-f366-40dc-9637-569f7d936a93	60
waitIncrementSeconds	438d433b-f366-40dc-9637-569f7d936a93	60
quickLoginCheckMilliSeconds	438d433b-f366-40dc-9637-569f7d936a93	1000
maxDeltaTimeSeconds	438d433b-f366-40dc-9637-569f7d936a93	43200
failureFactor	438d433b-f366-40dc-9637-569f7d936a93	30
realmReusableOtpCode	438d433b-f366-40dc-9637-569f7d936a93	false
displayName	438d433b-f366-40dc-9637-569f7d936a93	Keycloak
displayNameHtml	438d433b-f366-40dc-9637-569f7d936a93	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	438d433b-f366-40dc-9637-569f7d936a93	RS256
offlineSessionMaxLifespanEnabled	438d433b-f366-40dc-9637-569f7d936a93	false
offlineSessionMaxLifespan	438d433b-f366-40dc-9637-569f7d936a93	5184000
_browser_header.contentSecurityPolicyReportOnly	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	
_browser_header.xContentTypeOptions	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	nosniff
_browser_header.referrerPolicy	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	no-referrer
_browser_header.xRobotsTag	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	none
_browser_header.xFrameOptions	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	SAMEORIGIN
_browser_header.contentSecurityPolicy	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	1; mode=block
_browser_header.strictTransportSecurity	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	max-age=31536000; includeSubDomains
bruteForceProtected	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	false
permanentLockout	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	false
maxFailureWaitSeconds	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	900
minimumQuickLoginWaitSeconds	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	60
waitIncrementSeconds	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	60
quickLoginCheckMilliSeconds	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	1000
maxDeltaTimeSeconds	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	43200
failureFactor	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	30
realmReusableOtpCode	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	false
defaultSignatureAlgorithm	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	RS256
offlineSessionMaxLifespanEnabled	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	false
offlineSessionMaxLifespan	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	5184000
actionTokenGeneratedByAdminLifespan	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	43200
actionTokenGeneratedByUserLifespan	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	300
oauth2DeviceCodeLifespan	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	600
oauth2DevicePollingInterval	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	5
webAuthnPolicyRpEntityName	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	keycloak
webAuthnPolicySignatureAlgorithms	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	ES256
webAuthnPolicyRpId	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	
webAuthnPolicyAttestationConveyancePreference	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	not specified
webAuthnPolicyAuthenticatorAttachment	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	not specified
webAuthnPolicyRequireResidentKey	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	not specified
webAuthnPolicyUserVerificationRequirement	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	not specified
webAuthnPolicyCreateTimeout	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	0
webAuthnPolicyAvoidSameAuthenticatorRegister	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	false
webAuthnPolicyRpEntityNamePasswordless	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	ES256
webAuthnPolicyRpIdPasswordless	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	
webAuthnPolicyAttestationConveyancePreferencePasswordless	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	not specified
webAuthnPolicyRequireResidentKeyPasswordless	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	not specified
webAuthnPolicyUserVerificationRequirementPasswordless	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	not specified
webAuthnPolicyCreateTimeoutPasswordless	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	false
cibaBackchannelTokenDeliveryMode	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	poll
cibaExpiresIn	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	120
cibaInterval	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	5
cibaAuthRequestedUserHint	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	login_hint
parRequestUriLifespan	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	60
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
438d433b-f366-40dc-9637-569f7d936a93	jboss-logging
a465077b-0c7f-4fcc-bf69-d3f0805cefe5	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	438d433b-f366-40dc-9637-569f7d936a93
password	password	t	t	a465077b-0c7f-4fcc-bf69-d3f0805cefe5
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.redirect_uris (client_id, value) FROM stdin;
3d9f9d92-d9c3-4841-bac2-53911dd04736	/realms/master/account/*
7ef93169-e5b2-4ab7-89a6-7a2a555b443f	/realms/master/account/*
d3bccb88-8868-44c1-a6d8-bfa0109aa68d	/admin/master/console/*
b1a916a4-2007-45c9-8319-855c86912a45	/realms/example/account/*
0690e5c3-bdc8-4282-9122-b40b38ac6dcb	/realms/example/account/*
98422c57-622e-41c2-874c-22bdf43d32ee	/admin/example/console/*
538f0243-e35c-48c0-a255-b7c964a03715	*
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
386add6f-411c-4838-b78d-949f17369b49	VERIFY_EMAIL	Verify Email	438d433b-f366-40dc-9637-569f7d936a93	t	f	VERIFY_EMAIL	50
6e681187-c595-490f-9d3d-f943a7fd00b0	UPDATE_PROFILE	Update Profile	438d433b-f366-40dc-9637-569f7d936a93	t	f	UPDATE_PROFILE	40
ec6dc95d-2119-410d-adef-cd3dd3d33e27	CONFIGURE_TOTP	Configure OTP	438d433b-f366-40dc-9637-569f7d936a93	t	f	CONFIGURE_TOTP	10
34cc5a4c-c205-4093-bd0a-b748ccd53c00	UPDATE_PASSWORD	Update Password	438d433b-f366-40dc-9637-569f7d936a93	t	f	UPDATE_PASSWORD	30
9caa73fc-b040-4bec-a654-be372b02e134	TERMS_AND_CONDITIONS	Terms and Conditions	438d433b-f366-40dc-9637-569f7d936a93	f	f	TERMS_AND_CONDITIONS	20
d063745a-eac9-4dd0-9353-2e14049b372e	delete_account	Delete Account	438d433b-f366-40dc-9637-569f7d936a93	f	f	delete_account	60
bf9260bb-575b-4825-901d-8f6b8707b450	update_user_locale	Update User Locale	438d433b-f366-40dc-9637-569f7d936a93	t	f	update_user_locale	1000
9d654d12-fd74-47d8-b799-6ebe5aa8f6d4	webauthn-register	Webauthn Register	438d433b-f366-40dc-9637-569f7d936a93	t	f	webauthn-register	70
fe378d88-202a-46fe-8522-fa235c8efe15	webauthn-register-passwordless	Webauthn Register Passwordless	438d433b-f366-40dc-9637-569f7d936a93	t	f	webauthn-register-passwordless	80
5247488a-e167-4cda-bba0-00cf1e1de028	VERIFY_EMAIL	Verify Email	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	t	f	VERIFY_EMAIL	50
84669d1b-1937-4f9f-922d-6b807e1bf963	UPDATE_PROFILE	Update Profile	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	t	f	UPDATE_PROFILE	40
4ad7f3fe-dd93-405d-9bd3-a21dbbffab8c	CONFIGURE_TOTP	Configure OTP	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	t	f	CONFIGURE_TOTP	10
43ac703c-70ed-4ec3-980b-556994560185	UPDATE_PASSWORD	Update Password	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	t	f	UPDATE_PASSWORD	30
1da2a8aa-68c8-4769-aabf-3eaa013272e1	TERMS_AND_CONDITIONS	Terms and Conditions	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	f	f	TERMS_AND_CONDITIONS	20
f6bd8a18-059e-4e22-a7a0-52dfe44cb9f1	delete_account	Delete Account	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	f	f	delete_account	60
697f1349-cfc8-4da0-88d0-551b2e153d40	update_user_locale	Update User Locale	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	t	f	update_user_locale	1000
65cbcca1-64ce-4bdc-b309-b7790ac3a98b	webauthn-register	Webauthn Register	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	t	f	webauthn-register	70
9d63a0b7-436d-43ad-bd3b-9e4f3c5e73b7	webauthn-register-passwordless	Webauthn Register Passwordless	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	t	f	webauthn-register-passwordless	80
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
538f0243-e35c-48c0-a255-b7c964a03715	t	0	1
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
94d88ef1-3c93-44af-98b0-77908cb42851	Default Policy	A policy that grants access only for users within this realm	js	0	0	538f0243-e35c-48c0-a255-b7c964a03715	\N
478786ec-cdd8-4d59-ac93-0860e12d11b9	Default Permission	A permission that applies to the default resource type	resource	1	0	538f0243-e35c-48c0-a255-b7c964a03715	\N
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
e4501416-6299-4751-8e0a-3b2e68f7c40c	Default Resource	urn:app:resources:default	\N	538f0243-e35c-48c0-a255-b7c964a03715	538f0243-e35c-48c0-a255-b7c964a03715	f	\N
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_uris (resource_id, value) FROM stdin;
e4501416-6299-4751-8e0a-3b2e68f7c40c	/*
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
7ef93169-e5b2-4ab7-89a6-7a2a555b443f	16f404a0-ef99-4409-b4bb-b460d972dcca
7ef93169-e5b2-4ab7-89a6-7a2a555b443f	efb235ed-50d3-42e3-b99d-e567c7ecad36
0690e5c3-bdc8-4282-9122-b40b38ac6dcb	b8d13099-955f-4945-a9a5-d67e60edc5c5
0690e5c3-bdc8-4282-9122-b40b38ac6dcb	6316d4d6-39a5-4b63-8ee1-b47c266cee14
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_attribute (name, value, user_id, id) FROM stdin;
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
7fc35427-0949-489c-a10c-de4238fba2d6	\N	b05cd50e-6cca-4f16-873d-706b69672a7a	f	t	\N	\N	\N	438d433b-f366-40dc-9637-569f7d936a93	admin	1709901012408	\N	0
8e5969ed-0b49-405d-bac3-a527c2917056	\N	a3516a44-8731-4a7f-badb-321f82f1ddfb	f	t	\N	\N	\N	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	service-account-app	1709901176123	538f0243-e35c-48c0-a255-b7c964a03715	0
f07ea084-8941-4f5c-8195-a02c6386cdc7	user@example.com	user@example.com	t	t	\N	User	Example	a465077b-0c7f-4fcc-bf69-d3f0805cefe5	user	1709901338098	\N	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_group_membership (group_id, user_id) FROM stdin;
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
e8871570-ca3d-436d-813a-12ee4acd8c21	7fc35427-0949-489c-a10c-de4238fba2d6
47f8b3ac-d7d3-4819-91da-cfb9e15f7d46	7fc35427-0949-489c-a10c-de4238fba2d6
857a7058-8cf7-42e0-9c06-024b898eea5d	7fc35427-0949-489c-a10c-de4238fba2d6
fb87b87a-e9fe-4d05-b7c4-317e13464e0c	7fc35427-0949-489c-a10c-de4238fba2d6
e015c760-61a9-45af-ba40-927a31bee687	7fc35427-0949-489c-a10c-de4238fba2d6
2c4d9735-4529-47c6-97cd-618c3e9e8112	7fc35427-0949-489c-a10c-de4238fba2d6
1c3be4f3-59c9-4970-acef-04830b749197	7fc35427-0949-489c-a10c-de4238fba2d6
07078bc8-63d4-4512-b191-3f91586827de	7fc35427-0949-489c-a10c-de4238fba2d6
64cb8900-c38c-4e81-a6fb-1f9e670cdc95	7fc35427-0949-489c-a10c-de4238fba2d6
a42059e1-930c-42e7-bd73-ccc1a8b61207	7fc35427-0949-489c-a10c-de4238fba2d6
2d576204-2ca1-4095-872f-ca7e744c0822	7fc35427-0949-489c-a10c-de4238fba2d6
8b229319-e238-4837-9272-6e90d10c6016	7fc35427-0949-489c-a10c-de4238fba2d6
69a75e20-6900-49e4-b6ce-408a869e99cb	7fc35427-0949-489c-a10c-de4238fba2d6
6c6bded7-9c00-4870-b66b-8406531922ad	7fc35427-0949-489c-a10c-de4238fba2d6
44266fa4-f67d-4406-a6a9-09e528b8f18a	7fc35427-0949-489c-a10c-de4238fba2d6
5301f743-3edf-42f9-bd7f-50bc8378f19c	7fc35427-0949-489c-a10c-de4238fba2d6
780596a5-f019-4ca7-ae5f-466f111e86ea	7fc35427-0949-489c-a10c-de4238fba2d6
9ee436aa-aed3-4de0-96ea-ddb41f76db41	7fc35427-0949-489c-a10c-de4238fba2d6
05585f82-4cba-44ff-98bb-2e98e573ed09	7fc35427-0949-489c-a10c-de4238fba2d6
cf14231c-140c-4652-a5d6-27522144626a	8e5969ed-0b49-405d-bac3-a527c2917056
8347d537-33fd-4a01-9d02-c45ad64c6185	8e5969ed-0b49-405d-bac3-a527c2917056
cf14231c-140c-4652-a5d6-27522144626a	f07ea084-8941-4f5c-8195-a02c6386cdc7
\.


--
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_session (id, auth_method, ip_address, last_session_refresh, login_username, realm_id, remember_me, started, user_id, user_session_state, broker_session_id, broker_user_id) FROM stdin;
\.


--
-- Data for Name: user_session_note; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_session_note (user_session, name, value) FROM stdin;
\.


--
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.web_origins (client_id, value) FROM stdin;
d3bccb88-8868-44c1-a6d8-bfa0109aa68d	+
98422c57-622e-41c2-874c-22bdf43d32ee	+
538f0243-e35c-48c0-a255-b7c964a03715	+
\.


--
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: client_user_session_note constr_cl_usr_ses_note; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT constr_cl_usr_ses_note PRIMARY KEY (client_session, name);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: client_session_role constraint_5; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT constraint_5 PRIMARY KEY (client_session, role_id);


--
-- Name: user_session constraint_57; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_session
    ADD CONSTRAINT constraint_57 PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client_session_note constraint_5e; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT constraint_5e PRIMARY KEY (client_session, name);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: client_session constraint_8; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT constraint_8 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: client_session_auth_status constraint_auth_status_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT constraint_auth_status_pk PRIMARY KEY (client_session, authenticator);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: client_session_prot_mapper constraint_cs_pmp_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT constraint_cs_pmp_pk PRIMARY KEY (client_session, protocol_mapper_id);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: user_session_note constraint_usn_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT constraint_usn_pk PRIMARY KEY (user_session, name);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_jkuwuvd56ontgsuhogm8uewrt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_jkuwuvd56ontgsuhogm8uewrt UNIQUE (client_id, client_storage_provider, external_client_id, user_id);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_client_session_session; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_session_session ON public.client_session USING btree (session_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_css_preload; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_css_preload ON public.offline_client_session USING btree (client_id, offline_flag);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_offline_uss_by_usersess; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_usersess ON public.offline_user_session USING btree (realm_id, offline_flag, user_session_id);


--
-- Name: idx_offline_uss_createdon; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_createdon ON public.offline_user_session USING btree (created_on);


--
-- Name: idx_offline_uss_preload; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_preload ON public.offline_user_session USING btree (offline_flag, created_on, user_session_id);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_us_sess_id_on_cl_sess; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_us_sess_id_on_cl_sess ON public.offline_client_session USING btree (user_session_id);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: client_session_auth_status auth_status_constraint; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT auth_status_constraint FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_session_note fk5edfb00ff51c2736; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT fk5edfb00ff51c2736 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: user_session_note fk5edfb00ff51d3472; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT fk5edfb00ff51d3472 FOREIGN KEY (user_session) REFERENCES public.user_session(id);


--
-- Name: client_session_role fk_11b7sgqw18i532811v7o2dv76; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT fk_11b7sgqw18i532811v7o2dv76 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session_prot_mapper fk_33a8sgqw18i532811v7o2dk89; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT fk_33a8sgqw18i532811v7o2dk89 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session fk_b4ao2vcvat6ukau74wbwtfqo1; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT fk_b4ao2vcvat6ukau74wbwtfqo1 FOREIGN KEY (session_id) REFERENCES public.user_session(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_user_session_note fk_cl_usr_ses_note; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT fk_cl_usr_ses_note FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

