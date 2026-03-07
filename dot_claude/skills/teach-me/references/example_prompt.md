# Prompt: Teach Me Ray & Distributed Computing for Data Pipelines

## Context

I'm an ML engineer running Ray Data pipelines on Kubernetes (via KubeRay). My
typical workload is an image processing pipeline: read metadata from parquet →
`map_batches` with a stateful class that downloads images from S3, encodes them,
extracts features → write to Lance format. The work is I/O-bound (S3 downloads),
not compute-bound.

I recently debugged a cluster underutilization issue. I had a 16-node cluster
(1 head + 15 workers, 2 CPUs / 16 GiB each, 32 CPUs total) but Ray's
autoscaler kept scaling it down to 6 CPUs. I don't know the exact reasons but I suspect
it's because my pipeline only requested
0.25 CPU total. The root causes were:

1. `ActorPoolStrategy(min_size=1)` — Ray only started 1 actor, requesting 0.25 CPU
2. `enableInTreeAutoscaling` was on, so Ray removed "idle" workers
3. `minReplicas: 1` allowed KubeRay to honor the scale-down

## What I Don't Understand

I have a shaky mental model of the following concepts and how they relate to each
other. I often confuse what is a physical thing vs. a logical/scheduling
abstraction.

### 1. Actors, Tasks, Workers, Nodes — What Maps to What?

- Is an actor a process? A thread? A container?
- What is the relationship between a Ray worker process and a Kubernetes pod? Note that
  I have close to 0 notion of Kubernetes. I know it manages "pods" and compute, but
  that's pretty much it. I also don't know why it's so popular and what are the
  alternatives.
- When I set `num_cpus=0.25` on an actor, what actually happens at the OS level?
  Does the actor get pinned to 25% of a core? Or is it purely a scheduling hint?
- Can multiple actors run inside the same worker process, or does each get its own?
- What is a "task" vs an "actor" in Ray? When does Ray Data use one vs the other?

### 2. CPU Slots as a Scheduling Currency

- I set `num_cpus=0.25` for I/O-bound actors. This lets Ray place 8 actors per
  2-CPU node. But nothing stops each actor from using 100% of a core, right?
- What happens if all 8 actors on a node suddenly become CPU-bound? Does Ray
  throttle them? Or do they just compete for the 2 physical cores?
- How should I think about choosing `num_cpus` for:
  - Pure I/O-bound work (download from S3, write to storage)
  - CPU-bound work (image resizing, JPEG encoding)
  - Mixed workloads (download then process)
  - GPU work

### 3. ActorPoolStrategy — min_size, max_size, and Autoscaling

- What is the actor pool? Is it a pre-allocated set of actors, or does Ray
  create/destroy them dynamically?
- What does min_size control exactly? Just the initial number of actors, or a
  floor that's maintained throughout?
- If I set min_size=128 and max_size=128, does Ray create all 128 immediately?
  Or does it ramp up?
- How does the actor pool interact with Ray's autoscaler? The autoscaler sees
  resource _requests_, not actual utilization — is that right?

### 4. Blocks, Batches, and Parallelism in Ray Data

- What is a "block" in Ray Data? How does it relate to a "batch"?
- I create num_blocks chunks from my DataFrame. Does each block get processed
  by exactly one actor? Or can blocks be split/merged?
- What determines the actual degree of parallelism — num_blocks, min_size,
  max_size, or something else?
- If I have 128 actors but only 50 blocks, what happens to the other 78 actors?

### 5. The Autoscaler, KubeRay, and Kubernetes — Who Controls What?

- There seem to be three layers of "scaling": Ray's autoscaler, KubeRay operator,
  and Kubernetes (Karpenter). How do they interact?
- `enableInTreeAutoscaling` — what does "in-tree" mean? What's the alternative?
- When should I use autoscaling vs. fixed-size clusters? My pipelines have a
  known workload size — is autoscaling ever useful for batch jobs?
- `replicas` vs `minReplicas` vs `maxReplicas` — who reads which field?

### 6. Object Store Memory

- Ray's logs showed "object store memory: 29.7% of available memory". What is
  the object store used for in a Ray Data pipeline?
- My pipeline passes PyArrow tables between operators. Do those go through the
  object store?
- When would I need to tune `object-store-memory`?

## How I'd Like You to Teach This

- Use **analogies** grounded in everyday concepts (e.g. a restaurant kitchen,
  a factory floor, an office) to build intuition before diving into technical
  details.
- Relate every concept back to **my specific pipeline** (S3 download → image
  processing → Lance write on a 32-CPU KubeRay cluster).
- Clearly distinguish **physical resources** (CPU cores, RAM, pods, nodes) from
  **scheduling abstractions** (CPU slots, actors, blocks).
- When a concept has a common misconception, call it out explicitly (e.g.
  "num_cpus=0.25 does NOT mean the actor only gets 25% of a core").
- Provide **decision heuristics** — rules of thumb for choosing values like
  num_cpus, min_size, max_size, batch_size given workload characteristics.
- Use **diagrams in ASCII/text** where it helps (e.g. showing how actors are
  placed onto nodes).

## My Setup for Reference

- Ray 2.53.0, KubeRay on Kubernetes with Karpenter
- Cluster: 1 head (2 CPU, 16 GiB) + 15 workers (2 CPU, 16 GiB each) = 32 CPUs
- Pipeline: `ray.data.from_pandas(chunks).map_batches(FeatureGenerator, num_cpus=0.25, compute=ActorPoolStrategy(...))` → `write_lance(...)`
- Workload: ~80% I/O (S3 download), ~20% CPU (resize + JPEG encode)
