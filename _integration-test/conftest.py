import os
import subprocess

import pytest

SENTRY_CONFIG_PY = "sentry/sentry.conf.py"
SENTRY_TEST_HOST = os.getenv("SENTRY_TEST_HOST", "http://localhost:9000")
TEST_USER = "test@example.com"
TEST_PASS = "test123TEST"


@pytest.fixture(scope="session")
def container_engine():
    if os.getenv("CONTAINER_ENGINE", "docker") == "podman":
        return "podman"

    return "docker"


@pytest.fixture(scope="session")
def docker_cmd(container_engine):
    if container_engine == "podman":
        return ("podman",)

    return ("docker",)


@pytest.fixture(scope="session")
def docker_compose_cmd(container_engine, docker_cmd):
    if container_engine == "podman":
        return (*docker_cmd, "compose", "--no-ansi")

    return (*docker_cmd, "compose", "--ansi", "never")


@pytest.fixture(scope="session", autouse=True)
def configure_self_hosted_environment(request, docker_compose_cmd):
    subprocess.run(
        [*docker_compose_cmd, "up", "--wait"],
        check=True,
        capture_output=True,
    )
    # Create test user
    subprocess.run(
        [
            *docker_compose_cmd,
            "exec",
            "-T",
            "web",
            "sentry",
            "createuser",
            "--force-update",
            "--superuser",
            "--email",
            TEST_USER,
            "--password",
            TEST_PASS,
            "--no-input",
        ],
        check=True,
        text=True,
    )


@pytest.fixture()
def setup_backup_restore_env_variables():
    os.environ["SENTRY_DOCKER_IO_DIR"] = os.path.join(os.getcwd(), "sentry")
    os.environ["SKIP_USER_CREATION"] = "1"
